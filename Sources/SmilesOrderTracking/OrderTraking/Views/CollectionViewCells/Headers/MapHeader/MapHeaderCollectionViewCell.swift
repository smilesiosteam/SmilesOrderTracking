//
//  MapHeaderCollectionViewCell.swift
//
//
//  Created by Ahmed Naguib on 16/11/2023.
//

import UIKit
import GoogleMaps

final class MapHeaderCollectionViewCell: UICollectionReusableView {
    
    @IBOutlet private weak var driverImage: UIImageView!
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var supportButton: UIButton!
    
    static let identifier = String(describing: MapHeaderCollectionViewCell.self)
    
    private weak var delegate: HeaderCollectionViewProtocol?
    // MARK: - Outlets
    override func awakeFromNib() {
        super.awakeFromNib()
        configControllers()
    }
    
    @IBAction private func dismissButtonTapped(_ sender: Any) {
        delegate?.didTappDismiss()
    }
    
    @IBAction private func supportButtonTapped(_ sender: Any) {
        delegate?.didTappSupport()
    }
    
    private func configControllers() {
        dismissButton.layer.cornerRadius = 20
        supportButton.layer.cornerRadius = 20
        driverImage.layer.cornerRadius = 50
        driverImage.backgroundColor = .red
        driverImage.layer.borderWidth = 4
        driverImage.layer.borderColor = UIColor.white.cgColor
        supportButton.setTitle(OrderTrackingLocalization.support.text, for: .normal)
        [supportButton, dismissButton].forEach({
            $0.fontTextStyle = .smilesTitle1
            $0.setTitleColor(.appRevampPurpleMainColor, for: .normal)
        })
    }
}
