//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/12/2023.
//

import Foundation

enum RateYourOrderSection: CaseIterable {
    case ratingForDisplay
    case itemRating
    case separatorLine
    case describeOrderExperience
    
    var section: Int {
        switch self {
        case .ratingForDisplay:
            return 0
        case .itemRating:
            return 1
        case .separatorLine:
            return 2
        case .describeOrderExperience:
            return 3
        }
    }
}
