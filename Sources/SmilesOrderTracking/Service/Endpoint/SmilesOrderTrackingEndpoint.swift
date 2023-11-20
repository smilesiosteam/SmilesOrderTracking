//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation

enum SmilesOrderTrackingEndpoint {
    case orderTrackingStatus
    
    var url: String {
        switch self {
        case .orderTrackingStatus:
            return "order/v1/order-tracking-status"
        }
    }
}
