//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 25/11/2023.
//

import Foundation

enum RatingStar {
    case count(Double)
    
    private func getRatingState(for stars: Double) -> RatingState {
        switch stars {
        case 1.0:
            return .init(count: 1, text: "Terrible", icon: .ratingStarFilledRedIcon)
        case 2.0:
            return .init(count: 2, text: "Bad", icon: .ratingStarFilledRedIcon)
        case 3.0:
            return .init(count: 3, text: "Ok", icon: .ratingStarFilledIcon)
        case 4.0:
            return .init(count: 4, text: "Good", icon: .ratingStarFilledGreenIcon)
        case 5.0:
            return .init(count: 5, text: "Great", icon: .ratingStarFilledGreenIcon)
        default:
            return .init(count: 0, text: "", icon: .ratingStarUnfilledLightIcon)
        }
    }
    
    var state: RatingState {
        switch self {
        case .count(let stars):
            return getRatingState(for: stars)
        }
    }
}
