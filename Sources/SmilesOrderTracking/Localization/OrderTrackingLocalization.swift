//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import Foundation

enum OrderTrackingLocalization {
    case support
    
    var text: String {
        switch self {
        case .support:
            "Support"
        }
    }
}
