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
import SDWebImage

protocol OrderRatingViewDelegate: AnyObject {
    func shouldOpenItemRatingViewController(with model: RateOrderResponse, orderItems: [OrderItemDetail])
    func shouldOpenFeedbackSuccessViewController(with model: RateOrderResponse)
    func shouldOpenGetSupport(with url: String)
    func ratingDidComplete()
}

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
    weak var delegate: OrderRatingViewDelegate?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appRevampFilterTextColor.withAlphaComponent(0.6)
        submitButtonState(enabled: false)
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
        viewModel?.getLiveChatUrl()
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
        viewModel?.statePublisher.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .popupTitle(let text):
                self.popupTitleLabel.text = text
            case .ratingTitle(let text):
                self.ratingTitleLabel.text = text
            case .ratingDescription(let text):
                if !text.isEmpty {
                    self.ratingDescriptionLabel.text = text
                    self.ratingDescriptionLabel.isHidden = false
                } else {
                    self.ratingDescriptionLabel.isHidden = true
                }
            case .showError(let message):
                self.showAlertWithOkayOnly(message: message)
            case .getOrderRatingResponse(let response):
                self.getOrderRatingResponse = response
            case .rateOrderResponse(let response):
                guard let response else { return }
                
                dismiss {
                    if let itemWiseRatingEnabled = response.itemLevelRatingEnable, itemWiseRatingEnabled {
                        self.delegate?.shouldOpenItemRatingViewController(with: response, orderItems: self.orderItems ?? [])
                    } else {
                        self.delegate?.shouldOpenFeedbackSuccessViewController(with: response)
                    }
                }
            case .ratingStarsData(let data):
                self.ratingStarsData = data
            case .orderItems(let items):
                self.orderItems = items
            case .liveChatUrl(let url):
                guard let url else { return }
                
                dismiss {
                    self.delegate?.shouldOpenGetSupport(with: url)
                }
            }
        }.store(in: &cancellables)
    }
    
    private func setStarsState(with rating: Double) {
        let starsData = ratingStarsData?[safe: Int(rating) - 1]
        self.submitButtonState(enabled: true)
        
        SDWebImageManager.shared.loadImage(with: URL(string: starsData?.ratingImage ?? ""), options: .continueInBackground, progress: nil) { image, data, error, _, _, _ in
            DispatchQueue.main.async {
                self.starsView.settings.filledImage = image
            }
        }
        
        self.starsTextLabel.text = starsData?.ratingFeedback
        self.selectedRating = self.createRatingObj(userRating: rating, ratingType: getOrderRatingResponse?.orderRating?[0].ratingType ?? "", ratingFeedback: starsData?.ratingFeedback ?? "")
    }
    
    private func createRatingObj(userRating: Double, ratingType: String, ratingFeedback: String) -> OrderRatingModel {
        let model = OrderRatingModel()
        model.ratingType = ratingType
        model.userRating = userRating
        model.ratingFeedback = ratingFeedback
        return model
    }
}

// MARK: - Create
extension OrderRatingViewController {
    static func create(with viewModel: OrderRatingViewModel, delegate: OrderRatingViewDelegate) -> OrderRatingViewController {
        let viewController = OrderRatingViewController(nibName: String(describing: OrderRatingViewController.self), bundle: .module)
        viewController.viewModel = viewModel
        viewController.delegate = delegate
        return viewController
    }
}
