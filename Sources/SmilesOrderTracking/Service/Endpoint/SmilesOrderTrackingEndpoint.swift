//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation

enum SmilesOrderTrackingEndpoint {
    case orderTrackingStatus
    case orderConfirmationStatus
    case orderChangeType
    case resumeOrder
    case pauseOrder
    case cancelOrder
    case submitOrderRating
    case getOrderRating
    
    var url: String {
        switch self {
        case .orderTrackingStatus:
            return "order/v1/order-tracking-status"
        case .orderConfirmationStatus:
            return "order/v1/order-confirm-status"
        case .orderChangeType:
            return "order/v1/change-type"
        case .resumeOrder:
            return "order/v1/resume-order"
        case .pauseOrder:
            return "order/v1/pause-order"
        case .cancelOrder:
            return "order/v1/cancel-order"
        case .submitOrderRating:
            return "order-review/v1/submit-reviews"
        case .getOrderRating:
            return "order-review/v1/order-rating"
        }
    }
}
