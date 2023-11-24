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
}

final class OrderTrackingRepository: OrderTrackingServiceable {
    private var networkRequest: Requestable
    private var baseUrl: String
    private var endPoint: SmilesOrderTrackingEndpoint

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String, endPoint: SmilesOrderTrackingEndpoint) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
        self.endPoint = endPoint
    }
  
    func getOrderTrackingStatusService(request: OrderTrackingStatusRequest) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.getOrderTrackingStatus(request: request)
        let request = endPoint.createRequest(
            baseUrl: self.baseUrl,
            endPoint: self.endPoint
        )
        
        return self.networkRequest.request(request)
    }
    
    func setOrderConfirmationStatusService(request: OrderTrackingStatusRequest) -> AnyPublisher<OrderTrackingStatusResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.setOrderConfirmationStatus(request: request)
        let request = endPoint.createRequest(
            baseUrl: self.baseUrl,
            endPoint: self.endPoint
        )
        
        return self.networkRequest.request(request)
    }
    
    func changeOrderTypeService(request: OrderTrackingStatusRequest) -> AnyPublisher<OrderChangeTypeResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.changeOrderType(request: request)
        let request = endPoint.createRequest(
            baseUrl: self.baseUrl,
            endPoint: self.endPoint
        )
        
        return self.networkRequest.request(request)
    }
    
    func resumeOrderService(request: OrderTrackingStatusRequest) -> AnyPublisher<BaseMainResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.resumeOrder(request: request)
        let request = endPoint.createRequest(
            baseUrl: self.baseUrl,
            endPoint: self.endPoint
        )
        
        return self.networkRequest.request(request)
    }
    
    func pauseOrderService(request: OrderTrackingStatusRequest) -> AnyPublisher<BaseMainResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.pauseOrder(request: request)
        let request = endPoint.createRequest(
            baseUrl: self.baseUrl,
            endPoint: self.endPoint
        )
        
        return self.networkRequest.request(request)
    }
    
    func cancelOrderService(request: OrderCancelRequest) -> AnyPublisher<OrderCancelResponse, NetworkError> {
        let endPoint = OrderTrackingRequestBuilder.cancelOrder(request: request)
        let request = endPoint.createRequest(
            baseUrl: self.baseUrl,
            endPoint: self.endPoint
        )
        
        return self.networkRequest.request(request)
    }
}
