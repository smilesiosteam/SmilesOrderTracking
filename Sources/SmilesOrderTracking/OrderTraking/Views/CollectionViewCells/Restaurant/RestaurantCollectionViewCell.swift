//
//  RestaurantCollectionViewCell.swift
//
//
//  Created by Shmeel Ahmed on 15/11/2023.
//

import UIKit
import SmilesUtilities

final class RestaurantCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var purchasedItemsLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var iconView: UIImageView!
    
    // MARK: - Properties
    private var viewModel = ViewModel()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configControllers()
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        nameLabel.setAlignment()
        purchasedItemsLabel.text = viewModel.items
        purchasedItemsLabel.setLineHeight(lineHeight: 8)
        iconView.setImageWithUrlString(viewModel.iconUrl ?? "")
        purchasedItemsLabel.setAlignment()
    }
    
    private func configControllers() {
        iconView.layer.cornerRadius = 8
        nameLabel.fontTextStyle = .smilesHeadline4
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        purchasedItemsLabel.fontTextStyle = .smilesBody3
        
    }
}

// MARK: - ViewModel
extension RestaurantCollectionViewCell {
    struct ViewModel: Equatable {
        var name: String?
        var iconUrl: String?
        var items: String?
    }
}
