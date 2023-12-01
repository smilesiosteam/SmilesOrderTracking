//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 29/11/2023.
//

import Foundation

struct OrderItemDetail: Codable {
    let itemName: String?
    let itemID: String?
    let userItemRating: Double?
    let itemImage: String?
    let rating: [Rating]?
    var ratingCount = 0.0
    var ratingFeedback: String?

    enum CodingKeys: String, CodingKey {
        case itemName
        case itemID = "itemId"
        case userItemRating
        case itemImage
        case rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.itemName = try container.decodeIfPresent(String.self, forKey: .itemName)
        self.itemID = try container.decodeIfPresent(String.self, forKey: .itemID)
        self.userItemRating = try container.decodeIfPresent(Double.self, forKey: .userItemRating)
        self.itemImage = try container.decodeIfPresent(String.self, forKey: .itemImage)
        self.rating = try container.decodeIfPresent([Rating].self, forKey: .rating)
    }
}
