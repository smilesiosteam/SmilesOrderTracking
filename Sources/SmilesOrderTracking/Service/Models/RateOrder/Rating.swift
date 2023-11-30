//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 29/11/2023.
//

import Foundation

struct Rating: Codable {
    let id: Int?
    let ratingFeedback: String?
    let ratingColor: String?
    let ratingImage: String?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case ratingFeedback
        case ratingColor
        case ratingImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.ratingFeedback = try container.decodeIfPresent(String.self, forKey: .ratingFeedback)
        self.ratingColor = try container.decodeIfPresent(String.self, forKey: .ratingColor)
        self.ratingImage = try container.decodeIfPresent(String.self, forKey: .ratingImage)
    }
}
