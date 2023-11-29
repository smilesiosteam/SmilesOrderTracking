//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 26/11/2023.
//

import Foundation

struct RatingState {
    let count: Int
    let text: String
    let icon: ImageResource
    
    init(count: Int, text: String, icon: ImageResource) {
        self.count = count
        self.text = text
        self.icon = icon
    }
}
