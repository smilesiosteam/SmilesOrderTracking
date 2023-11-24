//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 23/11/2023.
//

import UIKit
import Cosmos
import SmilesUtilities
import SmilesFontsManager

final public class OrderRatingViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var containerStackView: UIStackView! {
        didSet {
            containerStackView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16.0)
        }
    }
    @IBOutlet private weak var popupHandleContainerView: UIView!
    @IBOutlet private weak var popupHandleView: UIView! {
        didSet {
            popupHandleView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: popupHandleView.bounds.height / 2)
            popupHandleView.backgroundColor = .black.withAlphaComponent(0.2)
        }
    }
    @IBOutlet private weak var popupTitleContainerView: UIView!
    @IBOutlet private weak var popupTitleLabel: UILabel! {
        didSet {
            popupTitleLabel.textColor = .black
            popupTitleLabel.fontTextStyle = .smilesHeadline3
        }
    }
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .black.withAlphaComponent(0.2)
        }
    }
    @IBOutlet private weak var ratingInformationContainerView: UIView!
    @IBOutlet private weak var ratingTitleLabel: UILabel! {
        didSet {
            ratingTitleLabel.textColor = .black
            ratingTitleLabel.fontTextStyle = .smilesHeadline4
        }
    }
    @IBOutlet private weak var ratingDescriptionLabel: UILabel! {
        didSet {
            ratingDescriptionLabel.textColor = .black.withAlphaComponent(0.6)
            ratingDescriptionLabel.fontTextStyle = .smilesTitle1
        }
    }
    @IBOutlet private weak var starsContainerView: UIView!
    @IBOutlet private weak var starsView: CosmosView!
    @IBOutlet private weak var starsTextContainerView: UIView!
    @IBOutlet private weak var starsTextLabel: UILabel! {
        didSet {
            starsTextLabel.textColor = .black
            starsTextLabel.fontTextStyle = .smilesHeadline4
        }
    }
    @IBOutlet private weak var submitButtonContainerView: UIView!
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            submitButton.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 16.0)
            submitButton.setTitle(OrderTrackingLocalization.submit.text, for: .normal)
            submitButton.fontTextStyle = .smilesHeadline4
        }
    }
    @IBOutlet private weak var supportTextContainerView: UIView!
    @IBOutlet private weak var supportTextLabel: UILabel! {
        didSet {
            supportTextLabel.text = OrderTrackingLocalization.facedTroubleWithYourOrder.text
            supportTextLabel.textColor = .black.withAlphaComponent(0.6)
            supportTextLabel.fontTextStyle = .smilesBody3
        }
    }
    @IBOutlet private weak var getSupportButton: UIButton! {
        didSet {
            getSupportButton.setTitle(OrderTrackingLocalization.getSupport.text, for: .normal)
            getSupportButton.setTitleColor(.appRevampPurpleMainColor, for: .normal)
            getSupportButton.fontTextStyle = .smilesBody3
        }
    }
    
    // MARK: - Properties
    var viewModel: OrderRatingViewModel?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        submitButtonState(enabled: false)
        updatePopupState()
        configureUI()
    }
    
    // MARK: - Actions
    @IBAction private func submitButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction private func getSupportButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Methods
    private func submitButtonState(enabled: Bool) {
        if enabled {
            submitButton.backgroundColor = .appRevampPurpleMainColor
            submitButton.setTitleColor(.white, for: .normal)
            submitButton.isUserInteractionEnabled = true
        } else {
            submitButton.backgroundColor = .black.withAlphaComponent(0.1)
            submitButton.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
            submitButton.isUserInteractionEnabled = false
        }
    }
    
    private func updatePopupState() {
        popupTitleLabel.text = viewModel?.popupTitle
        ratingTitleLabel.text = viewModel?.ratingTitle
        ratingDescriptionLabel.text = viewModel?.ratingDescription
    }
    
    private func configureUI() {
        containerStackView.setCustomSpacing(8.0, after: popupHandleContainerView)
        containerStackView.setCustomSpacing(24.0, after: popupTitleContainerView)
        containerStackView.setCustomSpacing(16.0, after: ratingInformationContainerView)
        containerStackView.setCustomSpacing(4.0, after: starsContainerView)
        containerStackView.setCustomSpacing(24.0, after: starsTextContainerView)
        containerStackView.setCustomSpacing(16.0, after: submitButtonContainerView)
        containerStackView.setCustomSpacing(16.0, after: supportTextContainerView)
    }
}

// MARK: - Create
extension OrderRatingViewController {
    static public func create(with viewModel: OrderRatingViewModel) -> OrderRatingViewController {
        let viewController = OrderRatingViewController(nibName: String(describing: OrderRatingViewController.self), bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}
