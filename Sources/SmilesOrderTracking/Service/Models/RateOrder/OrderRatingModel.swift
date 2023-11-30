//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 24/11/2023.
//

import Foundation

final class OrderRatingModel: Codable {
    // MARK: - Properties
    var ratingType: String?
    var ratingFeedback: String?
    var userRating: Double?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case ratingType
        case userRating
        case ratingFeedback
    }
    
    // MARK: - Lifecycle
    init(ratingType: String? = nil, ratingFeedback: String? = nil, userRating: Double? = nil) {
        self.ratingType = ratingType
        self.ratingFeedback = ratingFeedback
        self.userRating = userRating
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.ratingType, forKey: .ratingType)
        try container.encodeIfPresent(self.userRating, forKey: .userRating)
        try container.encodeIfPresent(self.ratingFeedback, forKey: .ratingFeedback)
    }
}
