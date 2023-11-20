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
}
