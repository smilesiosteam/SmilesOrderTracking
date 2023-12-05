//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 29/11/2023.
//

import Foundation

struct OrderRating: Codable {
    var ratingType: String?
    var userRating: Int?
    var ratingTitle: String?
    var title: String?
    var image: String?
    var rating: [Rating]?
    var description: String?
    var ratingCount = 0.0
    var ratingFeedback: String?

    enum CodingKeys: String, CodingKey {
        case ratingType
        case userRating
        case ratingTitle
        case title
        case image
        case description
        case rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ratingType = try container.decodeIfPresent(String.self, forKey: .ratingType)
        self.userRating = try container.decodeIfPresent(Int.self, forKey: .userRating)
        self.ratingTitle = try container.decodeIfPresent(String.self, forKey: .ratingTitle)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.rating = try container.decodeIfPresent([Rating].self, forKey: .rating)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }
}
