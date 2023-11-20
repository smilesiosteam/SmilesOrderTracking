//
//  RestaurantCollectionViewCell.swift
//  
//
//  Created by Shmeel Ahmed on 15/11/2023.
//

import UIKit

final class RestaurantCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var purchasedItemsLabel: UILabel!
    
    static let identifier =  String(describing: RestaurantCollectionViewCell.self)
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var iconView: UIImageView!
    
    var viewModel = ViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        configControllers()
    }
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        purchasedItemsLabel.text = viewModel.items.joined(separator: "\n")
        configControllers()
    }
    private func configControllers() {
        iconView.image =  UIImage(resource: .pickupIcon)
        nameLabel.fontTextStyle = .smilesHeadline4
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        purchasedItemsLabel.fontTextStyle = .smilesBody3
    }
    
}

// MARK: - ViewModel
extension RestaurantCollectionViewCell {
    struct ViewModel {
        var name: String?
        var iconUrl: String?
        var items: [String] = []
    }
}

