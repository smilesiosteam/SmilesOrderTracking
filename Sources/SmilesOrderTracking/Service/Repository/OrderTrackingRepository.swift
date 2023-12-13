//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation
import Combine
import NetworkingLayer

protocol OrderTrackingServiceable {
    func getOrderTrackingStatusService(request: OrderTrackingStatusRequest) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError>
    func setOrderConfirmationStatusService(request: OrderTrackingStatusRequest) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError>
    func changeOrderTypeService(request: OrderTrackingStatusRequest) -> AnyPublisher<OrderChangeTypeResponse, NetworkError>
    func resumeOrderService(request: OrderTrackingStatusRequest) -> AnyPublisher<BaseMainResponse, NetworkError>
    func pauseOrderService(request: OrderTrackingStatusRequest) -> AnyPublisher<BaseMainResponse, NetworkError>
    func cancelOrderService(request: OrderCancelRequest) -> AnyPublisher<OrderCancelResponse, NetworkError>
    func submitOrderRatingService(request: RateOrderRequest) -> AnyPublisher<RateOrderResponse, NetworkError>
    func getOrderRatingService(request: GetOrderRatingRequest) -> AnyPublisher<GetOrderRatingResponse, NetworkError>
}

final class OrderTrackingRepository: OrderTrackingServiceable {
    // MARK: - Properties
    private let networkRequest: Requestable
    private let baseUrl: String
    
    // MARK: - Init
    init(networkRequest: Requestable, baseUrl: String) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
    }
  
    // MARK: - Functions
    func getOrderTrackingStatusService(request: OrderTrackingStatusRequest) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.getOrderTrackingStatus(request: request)
        let request = endPoint.createRequest(
            baseUrl: baseUrl,
            endPoint: .orderTrackingStatus
        )

        return networkRequest.request(request)
    }
    
    func setOrderConfirmationStatusService(request: OrderTrackingStatusRequest) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.setOrderConfirmationStatus(request: request)
        let request = endPoint.createRequest(
            baseUrl: baseUrl,
            endPoint: .orderConfirmationStatus
        )
        
        return networkRequest.request(request)
    }
    
    func changeOrderTypeService(request: OrderTrackingStatusRequest) -> AnyPublisher<OrderChangeTypeResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.changeOrderType(request: request)
        let request = endPoint.createRequest(
            baseUrl: baseUrl,
            endPoint: .orderChangeType
        )
        
        return networkRequest.request(request)
    }
    
    func resumeOrderService(request: OrderTrackingStatusRequest) -> AnyPublisher<BaseMainResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.resumeOrder(request: request)
        let request = endPoint.createRequest(
            baseUrl: baseUrl,
            endPoint: .resumeOrder
        )
        
        return networkRequest.request(request)
    }
    
    func pauseOrderService(request: OrderTrackingStatusRequest) -> AnyPublisher<BaseMainResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.pauseOrder(request: request)
        let request = endPoint.createRequest(
            baseUrl: baseUrl,
            endPoint: .pauseOrder
        )
        return networkRequest.request(request)
    }
    
    func cancelOrderService(request: OrderCancelRequest) -> AnyPublisher<OrderCancelResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.cancelOrder(request: request)
        let request = endPoint.createRequest(
            baseUrl: baseUrl,
            endPoint: .cancelOrder
        )
        return networkRequest.request(request)
    }
    
    func submitOrderRatingService(request: RateOrderRequest) -> AnyPublisher<RateOrderResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.submitOrderRating(request: request)
        let request = endPoint.createRequest(
            baseUrl: baseUrl,
            endPoint: .submitOrderRating
        )
        return networkRequest.request(request)
    }
    
    func getOrderRatingService(request: GetOrderRatingRequest) -> AnyPublisher<GetOrderRatingResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.getOrderRating(request: request)
        let request = endPoint.createRequest(
            baseUrl: baseUrl,
            endPoint: .getOrderRating
        )
        return networkRequest.request(request)
    }
}
