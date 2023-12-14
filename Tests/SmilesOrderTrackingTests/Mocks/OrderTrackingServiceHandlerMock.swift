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
    
    // MARK: - Properties
    var changeOrderTypeResponse: Result<OrderChangeTypeResponse, NetworkError> = .failure(.badURL(""))
    var setOrderConfirmationStatus: Result<OrderTrackingStatusResponse, NetworkError> = .failure(.badURL(""))
    var pauseOrderResponse: Result<BaseMainResponse, NetworkError> = .failure(.badURL(""))
    var getOrderTrackingStatus: Result<OrderTrackingStatusResponse, NetworkError> = .failure(.badURL(""))
    
    // MARK: - Mock Behaviours
    func getOrderTrackingStatus(orderId: String, orderStatus: String, orderNumber: String, isComingFromFirebase: Bool) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        Future<OrderTrackingStatusResponse, NetworkError> { promise in
            promise(self.getOrderTrackingStatus)
        }.eraseToAnyPublisher()
    }
    
    func setOrderConfirmationStatus(orderId: String, orderStatus: OrderTrackingType) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        Future<OrderTrackingStatusResponse, NetworkError> { promise in
            promise(self.setOrderConfirmationStatus)
        }.eraseToAnyPublisher()
    }
    
    func changeOrderType(orderId: String) -> AnyPublisher<OrderChangeTypeResponse, NetworkError> {
        Future<OrderChangeTypeResponse, NetworkError> { promise in
            promise(self.changeOrderTypeResponse)
        }.eraseToAnyPublisher()
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
        Future<BaseMainResponse, NetworkError> { promise in
            promise(self.pauseOrderResponse)
        }.eraseToAnyPublisher()
    }
}
