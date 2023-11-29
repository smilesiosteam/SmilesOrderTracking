//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 24/11/2023.
//

import Foundation

final class ItemRatings: Codable {
    // MARK: - Properties
    var itemId: String?
    var userRating: Double?
    var ratingFeedback: String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case itemId
        case userRating
        case ratingFeedback
    }
    
    // MARK: - Lifecycle
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.itemId, forKey: .itemId)
        try container.encodeIfPresent(self.userRating, forKey: .userRating)
        try container.encodeIfPresent(self.ratingFeedback, forKey: .ratingFeedback)
    }
}
