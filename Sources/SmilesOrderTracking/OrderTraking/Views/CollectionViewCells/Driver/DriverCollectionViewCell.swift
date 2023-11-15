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
        
        iconImageView.image = UIImage(resource: viewModel.iconImageResource ?? .driverIcon)
        titleLabel.text = viewModel.titleText
        descriptionLabel.text = viewModel.descriptionText
        actionButton.setImage(UIImage(resource: viewModel.actionButtonImageResource ?? .callIcon), for: .normal)
    }
}

// MARK: - ViewModel
extension DriverCollectionViewCell {
    struct ViewModel {
        var titleText: String?
        var descriptionText: String?
        var iconImageResource: ImageResource?
        var actionButtonImageResource: ImageResource?
        var delegate: DriverCellActionDelegate?
    }
}
