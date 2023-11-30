//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesBaseMainRequestManager
import SmilesLocationHandler

class OrderTrackingServiceHandler {
    func getOrderTrackingStatus(orderId: String, orderStatus: OrderTrackingType, orderNumber: String, isComingFromFirebase: Bool = false) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        
        let request = OrderTrackingStatusRequest(orderId: orderId)
        print(request)
        if isComingFromFirebase {
            var additionalInfo = [BaseMainResponseAdditionalInfo]()
            let orderStatusAdditionalInfo : BaseMainResponseAdditionalInfo = BaseMainResponseAdditionalInfo()
            orderStatusAdditionalInfo.name = "order_status"
            orderStatusAdditionalInfo.value = "\(orderStatus.rawValue)"
            additionalInfo.append(orderStatusAdditionalInfo)

            let orderNumberAdditionalInfo : BaseMainResponseAdditionalInfo = BaseMainResponseAdditionalInfo()
            orderNumberAdditionalInfo.name = "order_number"
            orderNumberAdditionalInfo.value = orderNumber
            additionalInfo.append(orderNumberAdditionalInfo)

            let orderIdAdditionalInfo : BaseMainResponseAdditionalInfo = BaseMainResponseAdditionalInfo()
            orderIdAdditionalInfo.name = "id"
            orderIdAdditionalInfo.value = orderId
            additionalInfo.append(orderIdAdditionalInfo)
            
            SmilesBaseMainRequestManager.shared.baseMainRequestConfigs?.additionalInfo = additionalInfo
        } else {
            SmilesBaseMainRequestManager.shared.baseMainRequestConfigs?.additionalInfo = []
        }
        
        let service = OrderTrackingRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .orderTrackingStatus
        )
        
        return service.getOrderTrackingStatusService(request: request)
    }
    
    func setOrderConfirmationStatus(orderId: String, orderStatus: OrderTrackingType) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        let request = OrderTrackingStatusRequest(orderId: orderId, orderStatus: orderStatus.rawValue)
        let service = OrderTrackingRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .orderConfirmationStatus
        )
        
        return service.setOrderConfirmationStatusService(request: request)
    }
    
    func changeOrderType(orderId: String) -> AnyPublisher<OrderChangeTypeResponse, NetworkError> {
        let request = OrderTrackingStatusRequest(orderId: orderId)
        let service = OrderTrackingRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .orderChangeType
        )
        
        return service.changeOrderTypeService(request: request)
    }
    
    func resumeOrder(orderId: String) -> AnyPublisher<BaseMainResponse, NetworkError> {
        let request = OrderTrackingStatusRequest(orderId: orderId)
        let service = OrderTrackingRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .resumeOrder
        )
        
        return service.resumeOrderService(request: request)
    }
    
    func pauseOrder(orderId: String) -> AnyPublisher<BaseMainResponse, NetworkError> {
        let request = OrderTrackingStatusRequest(orderId: orderId)
        let service = OrderTrackingRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .pauseOrder
        )
        
        return service.pauseOrderService(request: request)
    }
    
    func cancelOrder(orderId: String, rejectionReason:String?) -> AnyPublisher<OrderCancelResponse, NetworkError> {
        let request = OrderCancelRequest(orderId: orderId, rejectionReason: rejectionReason)
        if let userInfo = LocationStateSaver.getLocationInfo() {
            let requestUserInfo = SmilesUserInfo()
            requestUserInfo.mambaId = userInfo.mambaId
            requestUserInfo.locationId = userInfo.locationId
            request.userInfo = requestUserInfo
        }
        
        let service = OrderTrackingRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .cancelOrder
        )
        
        return service.cancelOrderService(request: request)
    }
    
    func submitOrderRating(orderNumber: String, orderId: String, restaurantName: String, itemRatings: [ItemRatings]?, orderRating: [OrderRatingModel]?, isAccrualPointsAllowed: Bool, itemLevelRatingEnabled: Bool, restaurantId: String?) -> AnyPublisher<RateOrderResponse, NetworkError> {
        
        let request = RateOrderRequest(orderId: orderId, orderNumber: orderNumber, restaurantName: restaurantName, orderRatings: orderRating, itemRatings: itemRatings, isAccuralPointsAllowed: isAccrualPointsAllowed, itemLevelRatingEnabled: itemLevelRatingEnabled, restaurantId: restaurantId)
        if let userInfo = LocationStateSaver.getLocationInfo() {
            request.userInfo = userInfo
        }
        
        let service = OrderTrackingRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .submitOrderRating
        )
        
        return service.submitOrderRatingService(request: request)
    }
    
    func getOrderRating(ratingType: String, contentType: String, isLiveTracking: Bool, orderId: String) -> AnyPublisher<GetOrderRatingResponse, NetworkError> {
        
        let request = GetOrderRatingRequest(ratingType: ratingType, contentType: contentType, isLiveTracking: isLiveTracking, orderId: orderId)
        if let userInfo = LocationStateSaver.getLocationInfo() {
            request.userInfo = userInfo
        }
        
        let service = OrderTrackingRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .getOrderRating
        )
        
        return service.getOrderRatingService(request: request)
    }
}