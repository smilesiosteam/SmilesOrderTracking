//
//  LocationCollectionViewCell.swift
//
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

protocol LocationCollectionViewProtocol: AnyObject {
    func didTappCallRestaurant(mobileNumber: String?)
    func didTappOrderDetails(orderId: String)
    func didTappCancelDetails(orderId: String)
}

extension LocationCollectionViewProtocol{
    func didTappCallRestaurant(mobileNumber: String?) {}
    func didTappOrderDetails(orderId: String) {}
    func didTappCancelDetails(orderId: String) {}
}

final class LocationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var startAddressLabel: UILabel!
    @IBOutlet private weak var endAddressLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var endImage: UIImageView!
    @IBOutlet private weak var cancelOrderButton: UIButton!
    @IBOutlet private weak var startImage: UIImageView!
    @IBOutlet private weak var orderDetailsButton: UIButton!
    @IBOutlet private weak var callRestrantButton: UIButton!
    @IBOutlet private weak var stackDetails: UIStackView!
    
    // MARK: - Properties
    
    static let identifier = String(describing: LocationCollectionViewCell.self)
    
    private var viewModel: ViewModel = .init()
    private weak var delegate: LocationCollectionViewProtocol?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configControllers()
        configFont()
        configCellType()
    }
    
    // MARK: - Button Actions
    @IBAction func callRestrantTapped(_ sender: Any) {
        delegate?.didTappCallRestaurant(mobileNumber: viewModel.restaurantNumber)
    }
    
    @IBAction func orderDetailsTapped(_ sender: Any) {
        delegate?.didTappOrderDetails(orderId: viewModel.orderId)
    }
    
    @IBAction func cancelOrderTapped(_ sender: Any) {
        delegate?.didTappCancelDetails(orderId: viewModel.orderId)
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel, delegate: LocationCollectionViewProtocol) {
        self.delegate = delegate
        self.viewModel = viewModel
//        startAddressLabel.text = viewModel.startAddress
//        endAddressLabel.text = viewModel.endAddress
        configCellType()
    }
    
    private func configControllers() {
        endImage.image = UIImage(resource: .endAddress)
        startImage.image = UIImage(resource: .startAddress)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
    
    private func configFont() {
        startAddressLabel.fontTextStyle = .smilesBody2
        endAddressLabel.fontTextStyle = .smilesBody2
        
        cancelOrderButton.setTitle(OrderTrackingLocalization.cancelOrder.text, for: .normal)
        callRestrantButton.setTitle(OrderTrackingLocalization.callRestaurant.text, for: .normal)
        orderDetailsButton.setTitle(OrderTrackingLocalization.orderDetails.text, for: .normal)
        
        [cancelOrderButton, callRestrantButton, orderDetailsButton].forEach({
            $0?.fontTextStyle = .smilesTitle1
            $0?.setTitleColor(.appRevampPurpleMainColor, for: .normal)
        })
    }
    
    private func configCellType() {
        switch viewModel.type {
        case .cancel:
            stackDetails.isHidden = true
            cancelOrderButton.isHidden = false
        case .details:
            stackDetails.isHidden = false
            cancelOrderButton.isHidden = true
        }
    }
}

// MARK: - ViewModel
extension LocationCollectionViewCell {
    enum CellType {
        case cancel
        case details
    }
    
    struct ViewModel {
        var startAddress: String?
        var endAddress: String?
        var orderId: String = ""
        var restaurantNumber: String?
        var type: CellType = .cancel
    }
}
