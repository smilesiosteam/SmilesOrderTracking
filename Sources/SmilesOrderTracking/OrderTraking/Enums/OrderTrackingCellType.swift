//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 15/11/2023.
//

import Foundation

enum OrderTrackingCellType {
    case delivery
    case pickup
    
    var text: String {
        switch self {
        case .delivery:
            return "DELIVERY"
        case .pickup:
            return "PICK_UP"
        }
    }
}
