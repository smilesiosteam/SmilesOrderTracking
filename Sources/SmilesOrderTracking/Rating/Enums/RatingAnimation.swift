//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 28/11/2023.
//

import Foundation

enum RatingAnimation {
    case feedBackThumbsUp
    
    var name: String {
        switch self {
        case .feedBackThumbsUp:
            return "Thank you for sending your feedback 198x169"
        }
    }
}
