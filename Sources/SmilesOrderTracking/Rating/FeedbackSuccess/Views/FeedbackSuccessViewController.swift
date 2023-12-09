//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 29/11/2023.
//

import UIKit
import LottieAnimationManager
import SmilesFontsManager
import Combine
import SmilesUtilities

final public class FeedbackSuccessViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 12.0)
        }
    }
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var thankYouLabel: UILabel! {
        didSet {
            thankYouLabel.fontTextStyle = .smilesHeadline3
            thankYouLabel.textColor = .appDarkGrayColor
        }
    }
    @IBOutlet private weak var feedbackDescriptionLabel: UILabel! {
        didSet {
            feedbackDescriptionLabel.fontTextStyle = .smilesBody3
            feedbackDescriptionLabel.textColor = .appGreyColor_128
        }
    }
    @IBOutlet private weak var animationContainerView: UIView!
    @IBOutlet private weak var animationView: UIView!
    @IBOutlet private weak var okayButton: UIButton! {
        didSet {
            okayButton.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 12.0)
            okayButton.setTitle(OrderTrackingLocalization.okay.text, for: .normal)
            okayButton.setTitleColor(.white, for: .normal)
            okayButton.backgroundColor = .appPurpleColor1
            okayButton.fontTextStyle = .smilesTitle1
        }
    }
    @IBOutlet private weak var panGesture: UIPanGestureRecognizer!
    
    // MARK: - Properties
    private var viewModel: FeedbackSuccessViewModel?
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: OrderRatingViewDelegate?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appRevampFilterTextColor.withAlphaComponent(0.6)
        configureStackView()
        configureAnimation()
        bindViewModel()
        setupPanGesture()
        
        viewModel?.createUI()
    }
    
    // MARK: - Actions
    @IBAction private func okayTapped(_ sender: UIButton) {
        dismiss()
        delegate?.ratingDidComplete()
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
    
    private func bindViewModel() {
        viewModel?.statePublisher.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .popupTitle(let text):
                self.thankYouLabel.text = text
            case .description(let text):
                self.feedbackDescriptionLabel.attributedText = text
            }
        }.store(in: &cancellables)
    }
    
    private func setupPanGesture() {
        panGesture.addTarget(self, action: #selector(handlePanGesture))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        let isDraggingDown = translation.y > 50
        if isDraggingDown {
            dismiss()
        }
    }
}

// MARK: - Create
extension FeedbackSuccessViewController {
    static func create(with viewModel: FeedbackSuccessViewModel) -> FeedbackSuccessViewController {
        let viewController = FeedbackSuccessViewController(nibName: String(describing: FeedbackSuccessViewController.self), bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}
