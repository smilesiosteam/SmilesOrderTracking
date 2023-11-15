//
//  RestaurantPurchasedItemCollectionViewCell.swift
//  
//
//  Created by Shmeel Ahmed on 15/11/2023.
//

import UIKit

class RestaurantPurchasedItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var itemTitle: UILabel!
    
    static let identifier =  String(describing: RestaurantPurchasedItemCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configControllers()
    }
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel) {
        itemTitle.text = viewModel.itemTitle
    }
    private func configControllers() {
        itemTitle.fontTextStyle = .smilesBody3
    }

}

extension RestaurantPurchasedItemCollectionViewCell {
    struct ViewModel {
        var itemTitle: String?
    }
}
