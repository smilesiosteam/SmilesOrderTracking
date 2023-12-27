//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 15/11/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

protocol RatingCellActionDelegate: AnyObject {
    func rateOrderDidTap(orderId: Int)
    func rateDeliveryDidTap(orderId: Int)
}

final class RatingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var deliveryRateImage: UIImageView!
    @IBOutlet private weak var foodRateImage: UIImageView!
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 12.0)
            containerView.addBorder(withBorderWidth: 1.0, borderColor: .black.withAlphaComponent(0.1))
        }
    }
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.fontTextStyle = .smilesHeadline3
            titleLabel.textColor = .black
            titleLabel.text = OrderTrackingLocalization.yourExperience.text
        }
    }
    @IBOutlet private weak var rateOrderStackView: UIStackView!
    @IBOutlet private weak var rateOrderLabel: UILabel! {
        didSet {
            rateOrderLabel.fontTextStyle = .smilesBody2
            rateOrderLabel.textColor = .black.withAlphaComponent(0.8)
        }
    }
    @IBOutlet private weak var rateDeliveryStackView: UIStackView!
    @IBOutlet private weak var rateDeliveryLabel: UILabel! {
        didSet {
            rateDeliveryLabel.fontTextStyle = .smilesBody2
            rateDeliveryLabel.textColor = .black.withAlphaComponent(0.8)
            rateDeliveryLabel.setAlignment()
        }
    }
    
    // MARK: - Properties
    weak var delegate: RatingCellActionDelegate?
    private var orderId: Int = 0
    
    // MARK: - Actions
    @IBAction private func foodRateTapped(_ sender: Any) {
        delegate?.rateOrderDidTap(orderId: orderId)
    }
    
    @IBAction private func deliveryRateTapped(_ sender: Any) {
        delegate?.rateDeliveryDidTap(orderId: orderId)
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel, delegate: RatingCellActionDelegate) {
        rateDeliveryStackView.isHidden = true
        rateOrderStackView.isHidden = true
        self.delegate = delegate
        self.orderId = viewModel.orderId
        for item in viewModel.items {
            configCell(with: item)
        }
    }
    
    private func configCell(with model: RateModel) {
        switch model.type {
        case .delivery:
            rateDeliveryStackView.isHidden = false
            rateDeliveryLabel.text = model.title
            deliveryRateImage.setImageWithUrlString(model.iconUrl ?? "")
        case .food:
            rateOrderStackView.isHidden = false
            rateOrderLabel.text = model.title
            foodRateImage.setImageWithUrlString(model.iconUrl ?? "")
        }
    }
}

// MARK: - ViewModel
extension RatingCollectionViewCell {
    struct ViewModel: Equatable {
        var orderId: Int = 0
        var items: [RateModel] = []
    }
    
    enum RateType: String {
        case delivery = "delivery"
        case food = "food"
    }
    
    struct RateModel: Equatable {
        var type: RateType
        var title: String?
        var iconUrl: String?
    }
}
