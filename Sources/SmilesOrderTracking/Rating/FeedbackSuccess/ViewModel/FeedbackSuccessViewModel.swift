//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 30/11/2023.
//

import UIKit
import Combine
import SmilesFontsManager
import SmilesUtilities

final class FeedbackSuccessViewModel {
    private(set) var feedBackSuccessUIModel: FeedbackSuccessUIModel
    private var stateSubject: PassthroughSubject<State, Never> = .init()
    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    init(feedBackSuccessUIModel: FeedbackSuccessUIModel) {
        self.feedBackSuccessUIModel = feedBackSuccessUIModel
    }
    
    func createUI() {
        stateSubject.send(.popupTitle(text: feedBackSuccessUIModel.popupTitle))
        let attributedString = NSMutableAttributedString()
        let font = UIFont.circularXXTTBookFont(size: 14)
        attributedString.append(NSAttributedString(string: feedBackSuccessUIModel.boldText, attributes: [.font: font, .foregroundColor: UIColor.appDarkGrayColor]))
        attributedString.append(NSAttributedString(string: feedBackSuccessUIModel.description, attributes: [.font: font, .foregroundColor: UIColor.appGreyColor_128]))
        stateSubject.send(.description(text: attributedString))
    }
}

extension FeedbackSuccessViewModel {
    enum State {
        case popupTitle(text: String)
        case description(text: NSMutableAttributedString?)
    }
}
