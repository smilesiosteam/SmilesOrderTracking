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
    static let identifier = String(describing: RatingCollectionViewCell.self)
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    @IBAction private func rateOrderButtonTapped(_ sender: UIButton) {
        rateOrderButtonCollection.forEach { button in
            if button.tag <= sender.tag {
                button.setImage(UIImage(resource: .ratingStarFilledIcon), for: .normal)
            } else {
                button.setImage(UIImage(resource: .ratingStarUnfilledIcon), for: .normal)
            }
        }
        
        delegate?.rateOrderDidTap(rating: sender.tag)
    }
    
    @IBAction private func rateDeliveryButtonTapped(_ sender: UIButton) {
        rateDeliveryButtonCollection.forEach { button in
            if button.tag <= sender.tag {
                button.setImage(UIImage(resource: .ratingStarFilledIcon), for: .normal)
            } else {
                button.setImage(UIImage(resource: .ratingStarUnfilledIcon), for: .normal)
            }
        }
        
        delegate?.rateDeliveryDidTap(rating: sender.tag)
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel) {
//        delegate = viewModel.delegate
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
        var cellType: OrderTrackingCellType = .delivery
//        var delegate: RatingCellActionDelegate?
    }
}
