//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 16/11/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

protocol OrderConfirmationCellActionDelegate: AnyObject {
    func didGetTheOrder(with orderId: String, orderNumber: String)
    func didNotGetTheOrder(with orderId: String, orderNumber: String)
}

final class OrderConfirmationCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 12.0)
            containerView.addBorder(withBorderWidth: 1.0, borderColor: .black.withAlphaComponent(0.1))
        }
    }
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.fontTextStyle = .smilesHeadline4
            titleLabel.textColor = .black
            titleLabel.text = OrderTrackingLocalization.pendingDeliveryConfirmation.text
        }
    }
    @IBOutlet private weak var questionLabel: UILabel! {
        didSet {
            questionLabel.fontTextStyle = .smilesBody2
            questionLabel.textColor = .black.withAlphaComponent(0.8)
        }
    }
    @IBOutlet private weak var confirmButton: UIButton! {
        didSet {
            confirmButton.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: confirmButton.bounds.height / 2)
            confirmButton.setTitle(OrderTrackingLocalization.yesTitle.text.capitalizingFirstLetter(), for: .normal)
            confirmButton.setTitleColor(.white, for: .normal)
            confirmButton.fontTextStyle = .smilesHeadline4
            confirmButton.backgroundColor = .appRevampPurpleMainColor
        }
    }
    @IBOutlet private weak var denyButton: UIButton! {
        didSet {
            denyButton.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: denyButton.bounds.height / 2)
            denyButton.addBorder(withBorderWidth: 2.0, borderColor: .appRevampPurpleMainColor.withAlphaComponent(0.4))
            denyButton.setTitle(OrderTrackingLocalization.noTitle.text, for: .normal)
            denyButton.setTitleColor(.appRevampPurpleMainColor, for: .normal)
            denyButton.fontTextStyle = .smilesHeadline4
            denyButton.backgroundColor = .white
        }
    }
    
    // MARK: - Properties
    private weak var delegate: OrderConfirmationCellActionDelegate?
    private var viewModel = ViewModel()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    // MARK: - Actions
    @IBAction private func confirmButtonTapped(_ sender: UIButton) {
        delegate?.didGetTheOrder(with: viewModel.orderId, orderNumber: viewModel.orderNumber)
    }
    
    @IBAction private func denyButtonTapped(_ sender: UIButton) {
        delegate?.didNotGetTheOrder(with: viewModel.orderId, orderNumber: viewModel.orderNumber)
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel, delegate: OrderConfirmationCellActionDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        questionLabel.text = viewModel.question
        questionLabel.setAlignment()
    }
    
    private func configCell() {
        containerStackView.setCustomSpacing(8.0, after: titleStackView)
        containerStackView.setCustomSpacing(24.0, after: questionLabel)
    }
}

// MARK: - ViewModel
extension OrderConfirmationCollectionViewCell {
    struct ViewModel: Equatable {
        var question: String?
        var orderId: String = ""
        var orderNumber: String = ""
    }
}
