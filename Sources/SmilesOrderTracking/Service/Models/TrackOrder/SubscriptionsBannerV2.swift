//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation

struct SubscriptionsBannerV2: Codable {
    var redirectionUrl: String?
    var bannerImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case redirectionUrl
        case bannerImageUrl
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        redirectionUrl = try values.decodeIfPresent(String.self, forKey: .redirectionUrl)
        bannerImageUrl = try values.decodeIfPresent(String.self, forKey: .bannerImageUrl)
    }
}
