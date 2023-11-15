//
//  LocationCollectionViewCell.swift
//
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import UIKit

final class LocationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var startAddressLabel: UILabel!
    @IBOutlet private weak var endAddressLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var endImage: UIImageView!
    @IBOutlet private weak var startImage: UIImageView!
    
    static let identifier =  String(describing: LocationCollectionViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        configControllers()
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel) {
        startAddressLabel.text = viewModel.startAddress
        endAddressLabel.text = viewModel.endAddress
        configControllers()
    }
    
    private func configControllers() {
    
      
        endImage.image =  UIImage(resource: .endAddress)
        
        startImage.image =  UIImage(resource: .startAddress)
        
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
        var type: CellType = .cancel
    }
}
