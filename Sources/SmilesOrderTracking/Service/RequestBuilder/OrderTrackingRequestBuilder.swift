//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities

// if you wish you can have multiple services like this in a project
enum OrderTrackingRequestBuilder {
    // organise all the end points here for clarity
    case getOrderTrackingStatus(request: OrderTrackingStatusRequest)
    case setOrderConfirmationStatus(request: OrderTrackingStatusRequest)
    case changeOrderType(request: OrderTrackingStatusRequest)
    case resumeOrder(request: OrderTrackingStatusRequest)
    case pauseOrder(request: OrderTrackingStatusRequest)
    case cancelOrder(request: OrderCancelRequest)
    case submitOrderRating(request: RateOrderRequest)
    case getOrderRating(request: GetOrderRatingRequest)
    
    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getOrderTrackingStatus:
            return .POST
        case .setOrderConfirmationStatus:
            return .POST
        case .changeOrderType:
            return .POST
        case .resumeOrder:
            return .POST
        case .pauseOrder:
            return .POST
        case .cancelOrder:
            return .POST
        case .submitOrderRating:
            return .POST
        case .getOrderRating:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(endPoint: SmilesOrderTrackingEndpoint) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(from: AppCommonMethods.serviceBaseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getOrderTrackingStatus(let request):
            return request
        case .setOrderConfirmationStatus(let request):
            return request
        case .changeOrderType(let request):
            return request
        case .resumeOrder(let request):
            return request
        case .pauseOrder(let request):
            return request
        case .cancelOrder(let request):
            return request
        case .submitOrderRating(let request):
            return request
        case .getOrderRating(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(from baseUrl: String, for endPoint: SmilesOrderTrackingEndpoint) -> String {
        let endPoint = endPoint.url
        
        switch self {
        case .getOrderTrackingStatus:
            return "\(baseUrl)\(endPoint)"
        case .setOrderConfirmationStatus:
            return "\(baseUrl)\(endPoint)"
        case .changeOrderType:
            return "\(baseUrl)\(endPoint)"
        case .resumeOrder:
            return "\(baseUrl)\(endPoint)"
        case .pauseOrder:
            return "\(baseUrl)\(endPoint)"
        case .cancelOrder:
            return "\(baseUrl)\(endPoint)"
        case .submitOrderRating:
            return "\(baseUrl)\(endPoint)"
        case .getOrderRating:
            return "\(baseUrl)\(endPoint)"
        }
    }
}
