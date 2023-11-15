//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import Foundation

enum OrderTrackingLocalization {
    case support
    case callRestaurant
    case orderDetails
    case cancelOrder
    
    var text: String {
        switch self {
        case .support:
           return "Support"
        case .callRestaurant:
            return "Call restaurant"
        case .orderDetails:
            return "Order details"
        case .cancelOrder:
            return "Cancel order"
        }
    }
}
