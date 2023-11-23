//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 15/11/2023.
//

import UIKit
import SmilesFontsManager

// MARK: - Protocol
protocol DriverCellActionDelegate: AnyObject, PhoneCallable {
    func opneMap(lat: Double, lng: Double)
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
    private var viewModel: ViewModel = .init()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    @IBAction private func actionButtonTapped(_ sender: UIButton) {
        delegate?.didTappPhoneCall(with: viewModel.driverMobileNumber)
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel, delegate: DriverCellActionDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        
        switch viewModel.cellType {
        case .delivery:
            iconImageView.image = UIImage(resource: .driverIcon)
            actionButton.setImage(UIImage(resource: .callIcon), for: .normal)
            titleLabel.text = viewModel.title
            descriptionLabel.text = OrderTrackingLocalization.hasPickedUpYourOrder.text
        case .pickup:
            iconImageView.image = UIImage(resource: .pickupIcon)
            actionButton.setImage(UIImage(resource: .navigateToMapsIcon), for: .normal)
            titleLabel.text = OrderTrackingLocalization.pickUpYourOrderFrom.text + ":"
            descriptionLabel.text = viewModel.subTitle
        }
    }
}

// MARK: - ViewModel
extension DriverCollectionViewCell {
    struct ViewModel {
        var title: String?
        var subTitle: String?
        var driverMobileNumber: String?
        var lat: Double = 0.0
        var lng: Double = 0.0
        var cellType: OrderTrackingCellType = .delivery
    }
}
