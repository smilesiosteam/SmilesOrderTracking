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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel) {
        startAddressLabel.text = viewModel.startAddress
        endAddressLabel.text = viewModel.endAddress
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
