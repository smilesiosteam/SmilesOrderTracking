//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation

struct DelayAlert: Codable {
    var title: String?
    var description: String?
    var icon: String?
    var backgroundColor: String?

    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case icon
        case backgroundColor
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        backgroundColor = try values.decodeIfPresent(String.self, forKey: .backgroundColor)
    }
}
