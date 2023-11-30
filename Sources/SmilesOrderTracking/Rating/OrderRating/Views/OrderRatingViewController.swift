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
import Combine

final public class OrderRatingViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var panGesture: UIPanGestureRecognizer!
    @IBOutlet private weak var containerStackView: UIStackView! {
        didSet {
            containerStackView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 12.0)
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
            popupTitleLabel.textColor = .appDarkGrayColor
            popupTitleLabel.fontTextStyle = .smilesHeadline3
        }
    }
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .fullGreyColor
        }
    }
    @IBOutlet private weak var ratingInformationContainerView: UIView!
    @IBOutlet private weak var ratingTitleLabel: UILabel! {
        didSet {
            ratingTitleLabel.textColor = .appDarkGrayColor
            ratingTitleLabel.fontTextStyle = .smilesTitle1
        }
    }
    @IBOutlet private weak var ratingDescriptionLabel: UILabel! {
        didSet {
            ratingDescriptionLabel.textColor = .appGreyColor_128
            ratingDescriptionLabel.fontTextStyle = .smilesTitle2
        }
    }
    @IBOutlet private weak var starsContainerView: UIView!
    @IBOutlet private weak var starsView: CosmosView!
    @IBOutlet private weak var starsTextContainerView: UIView!
    @IBOutlet private weak var starsTextLabel: UILabel! {
        didSet {
            starsTextLabel.textColor = .appDarkGrayColor
            starsTextLabel.fontTextStyle = .smilesHeadline5
        }
    }
    @IBOutlet private weak var submitButtonContainerView: UIView!
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            submitButton.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 12.0)
            submitButton.setTitle(OrderTrackingLocalization.submit.text, for: .normal)
            submitButton.fontTextStyle = .smilesTitle1
        }
    }
    @IBOutlet private weak var supportTextContainerView: UIView!
    @IBOutlet private weak var supportTextLabel: UILabel! {
        didSet {
            supportTextLabel.text = OrderTrackingLocalization.facedTroubleWithYourOrder.text
            supportTextLabel.textColor = .appGreyColor_128
            supportTextLabel.fontTextStyle = .smilesLabel2
        }
    }
    @IBOutlet private weak var getSupportButton: UIButton! {
        didSet {
            getSupportButton.setTitle(OrderTrackingLocalization.getSupport.text, for: .normal)
            getSupportButton.setTitleColor(.appPurpleColor1, for: .normal)
            getSupportButton.fontTextStyle = .smilesLabel2
        }
    }
    
    // MARK: - Properties
    var viewModel: OrderRatingViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var ratingStarsData: [Rating]?
    private var selectedRating: OrderRatingModel?
    private var getOrderRatingResponse: GetOrderRatingResponse?
    private var orderItems: [OrderItemDetail]?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appRevampFilterTextColor.withAlphaComponent(0.6)
        submitButtonState(enabled: false)
        updatePopupState()
        configureUI()
        configureStarsState()
        setupPanGesture()
        bindViewModel()
        
        viewModel?.getOrderRating()
    }
    
    // MARK: - Actions
    @IBAction private func submitButtonTapped(_ sender: UIButton) {
        if let selectedRating {
            viewModel?.submitRating(with: selectedRating)
        }
    }
    
    @IBAction private func getSupportButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Methods
    private func submitButtonState(enabled: Bool) {
        if enabled {
            submitButton.backgroundColor = .appPurpleColor1
            submitButton.setTitleColor(.white, for: .normal)
            submitButton.isUserInteractionEnabled = true
        } else {
            submitButton.backgroundColor = .appButtonDisabledColor.withAlphaComponent(0.3)
            submitButton.setTitleColor(.appGreyColor_128.withAlphaComponent(0.5), for: .normal)
            submitButton.isUserInteractionEnabled = false
        }
    }
    
    private func updatePopupState() {
        popupTitleLabel.text = viewModel?.popupTitle
        ratingTitleLabel.text = viewModel?.ratingTitle
        if let ratingDescription = viewModel?.ratingDescription {
            ratingDescriptionLabel.text = ratingDescription
        } else {
            ratingDescriptionLabel.isHidden = true
        }
    }
    
    private func configureUI() {
        containerStackView.setCustomSpacing(16.0, after: popupHandleContainerView)
        containerStackView.setCustomSpacing(23.0, after: popupTitleContainerView)
        containerStackView.setCustomSpacing(16.0, after: ratingInformationContainerView)
        containerStackView.setCustomSpacing(4.0, after: starsContainerView)
        containerStackView.setCustomSpacing(24.0, after: starsTextContainerView)
        containerStackView.setCustomSpacing(24.0, after: submitButtonContainerView)
    }
    
    private func configureStarsState() {
        starsView.didFinishTouchingCosmos = { [weak self] stars in
            guard let self else { return }
            self.setStarsState(with: stars)
        }
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
    
    private func bindViewModel() {
        viewModel?.$getOrderRatingResponse.sink { [weak self] value in
            guard let self else { return }
            self.getOrderRatingResponse = value
        }.store(in: &cancellables)
        
        viewModel?.$rateOrderResponse.sink { [weak self] value in
            guard let self, let value else { return }
            
            dismiss {
                if let itemWiseRatingEnabled = value.itemLevelRatingEnable {
                    if itemWiseRatingEnabled {
                        self.openItemRatingViewController(with: value)
                    } else {
                        self.openFeedbackSuccessViewController(with: value)
                    }
                }
            }
        }.store(in: &cancellables)
        
        viewModel?.$popupTitle.sink { [weak self] value in
            guard let self else { return }
            self.popupTitleLabel.text = value
        }.store(in: &cancellables)
        
        viewModel?.$ratingTitle.sink { [weak self] value in
            guard let self else { return }
            self.ratingTitleLabel.text = value
        }.store(in: &cancellables)
        
        viewModel?.$ratingDescription.sink { [weak self] value in
            guard let self else { return }
            if let description = value, !description.isEmpty {
                self.ratingDescriptionLabel.text = description
            } else {
                self.ratingDescriptionLabel.isHidden = true
            }
        }.store(in: &cancellables)
        
        viewModel?.$orderItems.sink { [weak self] value in
            guard let self else { return }
            self.orderItems = value
        }.store(in: &cancellables)
    }
    
    private func setStarsState(with rating: Double) {
        let starsData = ratingStarsData?[safe: Int(rating) - 1]
        let orderRatingModel = RatingStar.data(starsData, rating, getOrderRatingResponse?.orderRating?[safe: 0]?.ratingType ?? "").state
        self.starsView.settings.filledImage = UIImage(url: URL(string: starsData?.ratingImage ?? ""))
        self.starsTextLabel.text = starsData?.ratingFeedback
        self.selectedRating = orderRatingModel
        self.submitButtonState(enabled: true)
    }
    
    private func openItemRatingViewController(with model: RateOrderResponse) {
        guard let viewModel = self.viewModel else { return }
        let itemRatingUIModel = ItemRatingUIModel(itemWiseRatingEnabled: model.itemLevelRatingEnable ?? false, isAccrualPointsAllowed: model.isAccrualPointsAllowed ?? false, orderItems: self.orderItems ?? [], ratingOrderResponse: model)
        let itemRatingViewModel = ItemRatingViewModel(itemRatingUIModel: itemRatingUIModel, serviceHandler: viewModel.serviceHandler)
        let itemRatingViewController = ItemRatingViewController.create(with: itemRatingViewModel)
        itemRatingViewController.modalPresentationStyle = .overFullScreen
        
        self.present(itemRatingViewController)
    }
    
    private func openFeedbackSuccessViewController(with model: RateOrderResponse) {
        let ratingOrderResult = model.ratingOrderResult
        let feedBackSuccessUIModel = FeedbackSuccessUIModel(popupTitle: ratingOrderResult?.title ?? "", description: ratingOrderResult?.description ?? "", boldText: ratingOrderResult?.accrualTitle ?? "")
        let feedBackSuccessViewModel = FeedbackSuccessViewModel(feedBackSuccessUIModel: feedBackSuccessUIModel)
        let feedBackSuccessViewController = FeedbackSuccessViewController.create(with: feedBackSuccessViewModel)
        feedBackSuccessViewController.modalPresentationStyle = .overFullScreen
        
        self.present(feedBackSuccessViewController)
    }
}

// MARK: - Create
extension OrderRatingViewController {
    static func create(with viewModel: OrderRatingViewModel) -> OrderRatingViewController {
        let viewController = OrderRatingViewController(nibName: String(describing: OrderRatingViewController.self), bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}
