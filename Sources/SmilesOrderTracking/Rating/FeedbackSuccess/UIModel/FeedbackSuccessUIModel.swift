//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 30/11/2023.
//

import Foundation

struct FeedbackSuccessUIModel {
    var popupTitle: String
    var description: String
    var boldText: String
    
    init(popupTitle: String, description: String, boldText: String) {
        self.popupTitle = popupTitle
        self.description = description
        self.boldText = boldText
    }
}
