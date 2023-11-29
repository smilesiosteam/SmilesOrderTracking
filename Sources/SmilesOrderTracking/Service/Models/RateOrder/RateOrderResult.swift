//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 28/11/2023.
//

import Foundation

struct RateOrderResult: Codable {
    // MARK: - Properties
    var title: String?
    var accrualTitle: String?
    var description: String?
    var accrualDescription: String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case title
        case accrualTitle = "accuralTitle"
        case description
        case accrualDescription = "accuralDescription"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.accrualTitle = try container.decodeIfPresent(String.self, forKey: .accrualTitle)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.accrualDescription = try container.decodeIfPresent(String.self, forKey: .accrualDescription)
    }
}
