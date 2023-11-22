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

struct OrderTrackingServiceHandler {    
    func getOrderTrackingStatus(orderId: String, orderStatus: OrderTrackingType, orderNumber: String, isComingFromFirebase: Bool = false) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        
        let request = OrderTrackingStatusRequest(orderId: orderId)
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
}
