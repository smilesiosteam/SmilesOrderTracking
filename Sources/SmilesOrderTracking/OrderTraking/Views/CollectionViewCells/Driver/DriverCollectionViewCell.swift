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
    func opneMap(lat: Double, lng: Double, placeName: String)
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
    
    // MARK: - Actions
    @IBAction private func actionButtonTapped(_ sender: UIButton) {
        switch viewModel.cellType {
        case .delivery:
            delegate?.didTappPhoneCall(with: viewModel.driverMobileNumber)
        case .pickup:
            delegate?.opneMap(lat: viewModel.lat, lng: viewModel.lng, placeName: viewModel.placeName)
        }
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel, delegate: DriverCellActionDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.subTitle
        titleLabel.setAlignment()
        descriptionLabel.setAlignment()
        switch viewModel.cellType {
        case .delivery:
            iconImageView.image = UIImage(resource: .driverIcon)
            actionButton.setImage(UIImage(resource: .phoneCallIcon), for: .normal)
            
            let mobile = viewModel.driverMobileNumber.asStringOrEmpty()
            actionButton.isHidden = mobile.isEmpty
        case .pickup:
            iconImageView.image = UIImage(resource: .pickupIcon)
            actionButton.setImage(UIImage(resource: .navigateToMapsIcon), for: .normal)
        }
    }
}

// MARK: - ViewModel
extension DriverCollectionViewCell {
    struct ViewModel: Equatable {
        var title: String?
        var subTitle: String?
        var driverMobileNumber: String?
        var lat: Double = 0.0
        var lng: Double = 0.0
        var placeName = ""
        var cellType: OrderTrackingCellType = .delivery
    }
}
