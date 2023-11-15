//
//  RestaurantCollectionViewCell.swift
//  
//
//  Created by Shmeel Ahmed on 15/11/2023.
//

import UIKit

final class RestaurantCollectionViewCell: UICollectionViewCell {
    
    static let identifier =  String(describing: LocationCollectionViewCell.self)
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var itemsCollectionView: UICollectionView!
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
        itemsCollectionView.reloadData()
        configControllers()
    }
    private func configControllers() {
        iconView.image =  UIImage(resource: .pickupIcon)
        nameLabel.fontTextStyle = .smilesHeadline4
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        itemsCollectionView.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: RestaurantCollectionViewCell.identifier)
    }
    
}

extension RestaurantCollectionViewCell:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantPurchasedItemCollectionViewCell.identifier, for: indexPath) as! RestaurantPurchasedItemCollectionViewCell
        itemCell.updateCell(with: RestaurantPurchasedItemCollectionViewCell.ViewModel(itemTitle: viewModel.items[indexPath.item]))
        return itemCell
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

