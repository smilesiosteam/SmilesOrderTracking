//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 13/12/2023.
//

import Foundation
import Combine
import NetworkingLayer
@testable import SmilesOrderTracking

final class OrderTrackingServiceHandlerMock: OrderTrackingServiceHandlerProtocol {
    func getOrderTrackingStatus(orderId: String, orderStatus: String, orderNumber: String, isComingFromFirebase: Bool) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        Just(OrderTrackingStatusResponse())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func setOrderConfirmationStatus(orderId: String, orderStatus: OrderTrackingType) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        Just(OrderTrackingStatusResponse())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func changeOrderType(orderId: String) -> AnyPublisher<OrderChangeTypeResponse, NetworkError> {
        Just(OrderChangeTypeResponse())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func cancelOrder(orderId: String, rejectionReason: String?) -> AnyPublisher<OrderCancelResponse, NetworkError> {
        Just(OrderCancelResponse())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func getOrderRating(ratingType: String, contentType: String, isLiveTracking: Bool, orderId: String) -> AnyPublisher<GetOrderRatingResponse, NetworkError> {
        Just(GetOrderRatingResponse())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func pauseOrder(orderId: String) -> AnyPublisher<BaseMainResponse, NetworkError> {
        Just(BaseMainResponse())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    
}
