//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 28/11/2023.
//

import Foundation

enum ItemRatingSection: CaseIterable {
    case ratingSuccess
    case itemRatingTitle
    case itemRating
    
    var section: Int {
        switch self {
        case .ratingSuccess:
            return 0
        case .itemRatingTitle:
            return 1
        case .itemRating:
            return 2
        }
    }
}
