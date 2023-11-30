//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 30/11/2023.
//

import UIKit
import Combine
import SmilesFontsManager

final class FeedbackSuccessViewModel {
    private(set) var feedBackSuccessUIModel: FeedbackSuccessUIModel
    @Published var popupTitle: String?
    @Published var description: NSMutableAttributedString?
    
    init(feedBackSuccessUIModel: FeedbackSuccessUIModel) {
        self.feedBackSuccessUIModel = feedBackSuccessUIModel
    }
    
    func createUI() {
        popupTitle = feedBackSuccessUIModel.popupTitle
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: feedBackSuccessUIModel.boldText, attributes: [.font: UIFont.preferredFont(forTextStyle: .smilesBody3), .foregroundColor: UIColor.appDarkGrayColor]))
        attributedString.append(NSAttributedString(string: feedBackSuccessUIModel.description, attributes: [.font: UIFont.preferredFont(forTextStyle: .smilesBody3), .foregroundColor: UIColor.appGreyColor_128]))
        description = attributedString
    }
}
