//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesBaseMainRequestManager

protocol OrderTrackingServiceHandlerProtocol {
    func getOrderTrackingStatus(orderId: String, orderStatus: String, orderNumber: String, isComingFromFirebase: Bool) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError>
    func setOrderConfirmationStatus(orderId: String, orderStatus: OrderTrackingType) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError>
    func changeOrderType(orderId: String) -> AnyPublisher<OrderChangeTypeResponse, NetworkError>
    func cancelOrder(orderId: String, rejectionReason:String?) -> AnyPublisher<OrderCancelResponse, NetworkError>
    func getOrderRating(ratingType: String, contentType: String, isLiveTracking: Bool, orderId: String) -> AnyPublisher<GetOrderRatingResponse, NetworkError>
    func pauseOrder(orderId: String) -> AnyPublisher<BaseMainResponse, NetworkError>
}

final class OrderTrackingServiceHandler: OrderTrackingServiceHandlerProtocol {
    
    // MARK: - Properties
    private let repository: OrderTrackingServiceable
    
    // MARK: - Init
    init(repository: OrderTrackingServiceable) {
        self.repository = repository
    }
    
    // MARK: - Functions
    func getOrderTrackingStatus(orderId: String, orderStatus: String, orderNumber: String, isComingFromFirebase: Bool) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        
        let request = OrderTrackingStatusRequest(orderId: orderId)
        if isComingFromFirebase {
            var additionalInfo = [BaseMainResponseAdditionalInfo]()
            let orderStatusAdditionalInfo : BaseMainResponseAdditionalInfo = BaseMainResponseAdditionalInfo()
            orderStatusAdditionalInfo.name = "order_status"
            orderStatusAdditionalInfo.value = "\(orderStatus)"
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
        return repository.getOrderTrackingStatusService(request: request)
    }
    
    func setOrderConfirmationStatus(orderId: String, orderStatus: OrderTrackingType) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        let request = OrderTrackingStatusRequest(orderId: orderId, orderStatus: orderStatus.rawValue)
        return repository.setOrderConfirmationStatusService(request: request)
    }
    
    func changeOrderType(orderId: String) -> AnyPublisher<OrderChangeTypeResponse, NetworkError> {
        let request = OrderTrackingStatusRequest(orderId: orderId)
        return repository.changeOrderTypeService(request: request)
    }
    
    func resumeOrder(orderId: String) -> AnyPublisher<BaseMainResponse, NetworkError> {
        let request = OrderTrackingStatusRequest(orderId: orderId)
        return repository.resumeOrderService(request: request)
    }
    
    func pauseOrder(orderId: String) -> AnyPublisher<BaseMainResponse, NetworkError> {
        let request = OrderTrackingStatusRequest(orderId: orderId)
        return repository.pauseOrderService(request: request)
    }
    
    func cancelOrder(orderId: String, rejectionReason:String?) -> AnyPublisher<OrderCancelResponse, NetworkError> {
        let request = OrderCancelRequest(orderId: orderId, rejectionReason: rejectionReason)
        return repository.cancelOrderService(request: request)
    }
    
    func submitOrderRating(orderNumber: String, orderId: String, restaurantName: String, itemRatings: [ItemRatings]?, orderRating: [OrderRatingModel]?, isAccrualPointsAllowed: Bool, itemLevelRatingEnabled: Bool, restaurantId: String?, userFeedback: String? = nil) -> AnyPublisher<RateOrderResponse, NetworkError> {
        
        let request = RateOrderRequest(orderId: orderId, orderNumber: orderNumber, restaurantName: restaurantName, orderRatings: orderRating, itemRatings: itemRatings, isAccuralPointsAllowed: isAccrualPointsAllowed, itemLevelRatingEnabled: itemLevelRatingEnabled, restaurantId: restaurantId, userFeedback: userFeedback)
        return repository.submitOrderRatingService(request: request)
    }
    
    func getOrderRating(ratingType: String, contentType: String, isLiveTracking: Bool, orderId: String) -> AnyPublisher<GetOrderRatingResponse, NetworkError> {
        
        let request = GetOrderRatingRequest(ratingType: ratingType, contentType: contentType, isLiveTracking: isLiveTracking, orderId: orderId)
        return repository.getOrderRatingService(request: request)
    }
}

