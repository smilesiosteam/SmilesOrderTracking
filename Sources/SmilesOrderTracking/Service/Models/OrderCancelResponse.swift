//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 23/11/2023.
//

import Foundation

public struct OrderCancelResponse: Codable {
    // MARK: - Properties
    var status: Int?
    var title: String?
    var description: String?
    var rejectionReasons: [String]?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case status
        case title
        case description
        case rejectionReasons
    }
    
    // MARK: - Lifecycle
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.rejectionReasons = try container.decodeIfPresent([String].self, forKey: .rejectionReasons)
    }
    public init(){}
}
