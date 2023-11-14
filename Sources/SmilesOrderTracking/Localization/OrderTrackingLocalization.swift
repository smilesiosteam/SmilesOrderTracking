//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import Foundation

enum OrderTrackingLocalization {
    case title
    
    var text: String {
        switch self {
        case .title:
            "Set key"
        }
    }
}
