//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation

struct OrderRatings: Codable {
    var ratingType: String?
    var title: String?
    var image: String?
    var userRating: Double?
    
    enum CodingKeys: String, CodingKey {
        case ratingType
        case title
        case image
        case userRating
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ratingType = try values.decodeIfPresent(String.self, forKey: .ratingType)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        userRating = try values.decodeIfPresent(Double.self, forKey: .userRating)
    }
}
