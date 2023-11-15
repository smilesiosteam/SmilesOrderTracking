//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 15/11/2023.
//

import UIKit
import SmilesFontsManager

// MARK: - Protocol
protocol DriverCellActionDelegate: AnyObject {
    func actionButtonDidTap()
}

final class DriverCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.fontTextStyle = .smilesHeadline3
            titleLabel.textColor = .black
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.fontTextStyle = .smilesBody3
            descriptionLabel.textColor = .black
        }
    }
    @IBOutlet private weak var actionButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: DriverCellActionDelegate?
    static let identifier =  String(describing: DriverCollectionViewCell.self)
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    @IBAction private func actionButtonTapped(_ sender: UIButton) {
        delegate?.actionButtonDidTap()
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel) {
        delegate = viewModel.delegate
        
        switch viewModel.cellType {
        case .delivery:
            iconImageView.image = UIImage(resource: .driverIcon)
            actionButton.setImage(UIImage(resource: .callIcon), for: .normal)
            titleLabel.text = viewModel.text
            descriptionLabel.text = OrderTrackingLocalization.hasPickedUpYourOrder.text
        case .pickup:
            iconImageView.image = UIImage(resource: .pickupIcon)
            actionButton.setImage(UIImage(resource: .navigateToMapsIcon), for: .normal)
            titleLabel.text = OrderTrackingLocalization.pickUpYourOrderFrom.text + ":"
            descriptionLabel.text = viewModel.text
        }
    }
}

// MARK: - ViewModel
extension DriverCollectionViewCell {
    struct ViewModel {
        var text: String?
        var cellType: OrderTrackingCellType = .delivery
        var delegate: DriverCellActionDelegate?
    }
}
