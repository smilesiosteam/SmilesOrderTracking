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
        
        titleLabel.text = viewModel.titleText
        descriptionLabel.text = viewModel.descriptionText
        configCell(with: viewModel.cellType)
    }
    
    private func configCell(with type: CellType) {
        switch type {
        case .delivery:
            iconImageView.image = UIImage(resource: .driverIcon)
            actionButton.setImage(UIImage(resource: .callIcon), for: .normal)
        case .pickup:
            iconImageView.image = UIImage(resource: .pickupIcon)
            actionButton.setImage(UIImage(resource: .navigateToMapsIcon), for: .normal)
        }
    }
}

// MARK: - ViewModel
extension DriverCollectionViewCell {
    enum CellType {
        case delivery
        case pickup
    }
    
    struct ViewModel {
        var titleText: String?
        var descriptionText: String?
        var cellType: CellType = .delivery
        var delegate: DriverCellActionDelegate?
    }
}
