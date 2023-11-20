//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 16/11/2023.
//

import UIKit

protocol OrderCancelledCellActionDelegate: AnyObject {
    func orderDetailsDidTap()
    func callRestaurantDidTap()
}

final class OrderCancelledCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 12.0)
            containerView.addBorder(withBorderWidth: 1.0, borderColor: .black.withAlphaComponent(0.1))
        }
    }
    @IBOutlet private weak var orderDetailsButton: UIButton! {
        didSet {
            orderDetailsButton.setTitle(OrderTrackingLocalization.orderDetails.text, for: .normal)
            orderDetailsButton.setTitleColor(.appRevampPurpleMainColor, for: .normal)
            orderDetailsButton.fontTextStyle = .smilesTitle1
        }
    }
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .black.withAlphaComponent(0.1)
        }
    }
    @IBOutlet private weak var callRestaurantButton: UIButton! {
        didSet {
            callRestaurantButton.setTitle(OrderTrackingLocalization.callRestaurant.text, for: .normal)
            callRestaurantButton.setTitleColor(.appRevampPurpleMainColor, for: .normal)
            callRestaurantButton.fontTextStyle = .smilesTitle1
        }
    }
    
    // MARK: - Properties
    weak var delegate: OrderCancelledCellActionDelegate?
    
    static let identifier = String(describing: OrderCancelledCollectionViewCell.self)
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    @IBAction private func orderDetailsButtonTapped(_ sender: UIButton) {
        delegate?.orderDetailsDidTap()
    }
    
    @IBAction private func callRestaurantButtonTapped(_ sender: UIButton) {
        delegate?.callRestaurantDidTap()
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel) {
        delegate = viewModel.delegate
    }
}

// MARK: - ViewModel
extension OrderCancelledCollectionViewCell {
    struct ViewModel {
        var delegate: OrderCancelledCellActionDelegate?
    }
}
