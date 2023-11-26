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
    func rateOrderDidTap(rating: Int)
    func rateDeliveryDidTap(rating: Int)
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
        }
    }
    @IBOutlet private weak var rateOrderStackView: UIStackView!
    @IBOutlet private weak var rateOrderLabel: UILabel! {
        didSet {
            rateOrderLabel.fontTextStyle = .smilesBody2
            rateOrderLabel.textColor = .black.withAlphaComponent(0.8)
        }
    }
    @IBOutlet private var rateOrderButtonCollection: [UIButton]!
    @IBOutlet private weak var rateDeliveryStackView: UIStackView!
    @IBOutlet private weak var rateDeliveryLabel: UILabel! {
        didSet {
            rateDeliveryLabel.fontTextStyle = .smilesBody2
            rateDeliveryLabel.textColor = .black.withAlphaComponent(0.8)
        }
    }
    @IBOutlet private var rateDeliveryButtonCollection: [UIButton]!
    
    // MARK: - Properties
    weak var delegate: RatingCellActionDelegate?
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    @IBAction private func foodRateTapped(_ sender: Any) {
        
    }
    
    @IBAction private func deliveryRateTapped(_ sender: Any) {
        
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel, delegate: RatingCellActionDelegate) {
        self.delegate = delegate
        configCell(with: viewModel.cellType)
    }
    
    private func configCell(with type: OrderTrackingCellType) {
        switch type {
        case .delivery:
            rateDeliveryStackView.isHidden = false
        case .pickup:
            rateDeliveryStackView.isHidden = true
        }
    }
}

// MARK: - ViewModel
extension RatingCollectionViewCell {
    struct ViewModel {
        var orderId: Int
        var items: [RateModel] = []
    }
    
    enum RateType: String {
        case delivery = "delivery"
        case food = "food"
    }
    
    struct RateModel {
        var type: RateType
        var title: String?
        var iconUrl: String?
    }
}
