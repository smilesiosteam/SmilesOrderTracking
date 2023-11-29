//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 29/11/2023.
//

import UIKit
import LottieAnimationManager

final public class FeedbackSuccessViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 12.0)
        }
    }
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var thankYouLabel: UILabel! {
        didSet {
            thankYouLabel.fontTextStyle = .smilesHeadline3
            thankYouLabel.textColor = .appDarkGrayColor
        }
    }
    @IBOutlet weak var feedbackDescriptionLabel: UILabel! {
        didSet {
            feedbackDescriptionLabel.fontTextStyle = .smilesBody3
            feedbackDescriptionLabel.textColor = .appGreyColor_128
        }
    }
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var okayButton: UIButton! {
        didSet {
            okayButton.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 12.0)
            okayButton.setTitle(OrderTrackingLocalization.okay.text, for: .normal)
            okayButton.setTitleColor(.white, for: .normal)
            okayButton.backgroundColor = .appPurpleColor1
            okayButton.fontTextStyle = .smilesTitle1
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appRevampFilterTextColor.withAlphaComponent(0.6)
        configureStackView()
        configureAnimation()
    }
    
    // MARK: - Actions
    @IBAction private func okayTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Methods
    private func configureStackView() {
        containerStackView.setCustomSpacing(8.0, after: thankYouLabel)
        containerStackView.setCustomSpacing(33.0, after: feedbackDescriptionLabel)
        containerStackView.setCustomSpacing(26.0, after: animationContainerView)
    }
    
    private func configureAnimation() {
        LottieAnimationManager.showAnimation(onView: animationView, withJsonFileName: RatingAnimation.feedBackThumbsUp.name, removeFromSuper: false, loopMode: .loop) { _ in }
    }
}

// MARK: - Create
extension FeedbackSuccessViewController {
    static public func create() -> FeedbackSuccessViewController {
        let viewController = FeedbackSuccessViewController(nibName: String(describing: FeedbackSuccessViewController.self), bundle: .module)
        return viewController
    }
}
