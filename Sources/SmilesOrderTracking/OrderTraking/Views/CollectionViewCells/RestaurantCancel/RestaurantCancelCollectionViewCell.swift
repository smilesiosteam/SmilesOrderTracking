//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 16/11/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

protocol RestaurantCancelCellActionDelegate: AnyObject {
    func viewAvailableRestaurantsDidTap()
}

final class RestaurantCancelCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 12.0)
            containerView.addBorder(withBorderWidth: 1.0, borderColor: .black.withAlphaComponent(0.1))
        }
    }
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.fontTextStyle = .smilesBody2
            titleLabel.text = OrderTrackingLocalization.restaurantCancelledOrder.text
            titleLabel.textColor = .black
            titleLabel.setAlignment()
        }
    }
    @IBOutlet private weak var actionButton: UIButton! {
        didSet {
            actionButton.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: actionButton.bounds.height / 2)
            actionButton.backgroundColor = .appRevampPurpleMainColor
            actionButton.setTitle(OrderTrackingLocalization.viewAvailableRestaurants.text, for: .normal)
            actionButton.fontTextStyle = .smilesHeadline4
            actionButton.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK: - Properties
    weak var delegate: RestaurantCancelCellActionDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    @IBAction private func actionButtonTapped(_ sender: UIButton) {
        delegate?.viewAvailableRestaurantsDidTap()
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel) {
        delegate = viewModel.delegate
    }
}

extension RestaurantCancelCollectionViewCell {
    struct ViewModel {
        var delegate: RestaurantCancelCellActionDelegate?
    }
}
