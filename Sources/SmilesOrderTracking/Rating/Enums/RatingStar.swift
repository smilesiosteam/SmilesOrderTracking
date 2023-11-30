//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 25/11/2023.
//

import Foundation

enum RatingStar {
    case data(Rating?, Double, String)
    
    private func getRatingState(for rating: Rating?, star: Double, ratingType: String) -> OrderRatingModel {
        switch star {
        case 1:
            return .init(ratingType: ratingType, ratingFeedback: rating?.ratingFeedback, userRating: 1)
        case 2:
            return .init(ratingType: ratingType, ratingFeedback: rating?.ratingFeedback, userRating: 2)
        case 3:
            return .init(ratingType: ratingType, ratingFeedback: rating?.ratingFeedback, userRating: 3)
        case 4:
            return .init(ratingType: ratingType, ratingFeedback: rating?.ratingFeedback, userRating: 4)
        case 5:
            return .init(ratingType: ratingType, ratingFeedback: rating?.ratingFeedback, userRating: 5)
        default:
            return .init(ratingType: "", ratingFeedback: "", userRating: 0)
        }
    }
    
    var state: OrderRatingModel {
        switch self {
        case .data(let rating, let star, let ratingType):
            return getRatingState(for: rating, star: star, ratingType: ratingType)
        }
    }
}
