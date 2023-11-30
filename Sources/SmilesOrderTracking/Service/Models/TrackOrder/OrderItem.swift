//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation

struct OrderItem: Codable {
    var discountPrice: Double?
    var isEggIncluded: Bool?
    var isVeg: Bool?
    var itemName: String?
    var instruction: String?
    var price: Double?
    var quantity: Int?
    var saveAmount: Double?
    var choicesName : [String]?
    var actualChoicePoints : Int?
    var inlineItemIncluded: Bool?
    
    var foodTypeImage: String {
        if let eggIncluded = isEggIncluded, eggIncluded {
            return "eggDot"
        }
        else if let veg = isVeg, veg {
            return "vegDot"
        }
        else {
            return "nonVegDot"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case discountPrice
        case isEggIncluded
        case isVeg
        case itemName
        case instruction
        case price
        case quantity
        case saveAmount
        case choicesName
        case actualChoicePoints
        case inlineItemIncluded
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        discountPrice = try values.decodeIfPresent(Double.self, forKey: .discountPrice)
        isEggIncluded = try values.decodeIfPresent(Bool.self, forKey: .isEggIncluded)
        isVeg = try values.decodeIfPresent(Bool.self, forKey: .isVeg)
        itemName = try values.decodeIfPresent(String.self, forKey: .itemName)
        instruction = try values.decodeIfPresent(String.self, forKey: .instruction)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        saveAmount = try values.decodeIfPresent(Double.self, forKey: .saveAmount)
        choicesName = try values.decodeIfPresent([String].self, forKey: .choicesName)
        actualChoicePoints = try values.decodeIfPresent(Int.self, forKey: .actualChoicePoints)
        inlineItemIncluded = try values.decodeIfPresent(Bool.self, forKey: .inlineItemIncluded)
    }
}
