//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation
import NetworkingLayer

// if you wish you can have multiple services like this in a project
enum OrderTrackingRequestBuilder {
    // organise all the end points here for clarity
    case getOrderTrackingStatus(request: OrderTrackingStatusRequest)
    
    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getOrderTrackingStatus:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(baseUrl: String, endPoint: SmilesOrderTrackingEndpoint) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(from: baseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getOrderTrackingStatus(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(from baseUrl: String, for endPoint: SmilesOrderTrackingEndpoint) -> String {
        let endPoint = endPoint.url
        
        switch self {
        case .getOrderTrackingStatus:
            return "\(baseUrl)\(endPoint)"
        }
    }
}
