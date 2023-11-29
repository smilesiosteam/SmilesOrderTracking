//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 28/11/2023.
//

import UIKit

protocol ItemRatingDataSourceDelegate: AnyObject {
    func collectionViewShouldReload()
}

final class ItemRatingDataSource: NSObject {
    // MARK: - Properties
    private let viewModel: ItemRatingViewModel
    weak var delegate: ItemRatingDataSourceDelegate?
    
    // MARK: - Lifecycle
    init(viewModel: ItemRatingViewModel) {
        self.viewModel = viewModel
    }
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            // Item
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
//            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: layoutSize.heightDimension
                ),
                subitems: [item]
            )
//            group.interItemSpacing = .fixed(16.0)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 23, trailing: 0)
            
            return section
        }
    }
}

extension ItemRatingDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        ItemRatingSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case ItemRatingSection.ratingSuccess.section:
            return 1
        case ItemRatingSection.itemRatingTitle.section:
            return 1
        case ItemRatingSection.itemRating.section:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case ItemRatingSection.ratingSuccess.section:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FoodRatingSuccessCollectionViewCell.self), for: indexPath) as? FoodRatingSuccessCollectionViewCell else { return UICollectionViewCell() }
            let viewModel = FoodRatingSuccessCollectionViewCell.ViewModel(thankYouText: "Thank you for your rating", pointsText: "You just received 50 Smiles points!", ratingSuccessDescription: "Your review will help other users choose restuarants and help the restuarant maintain quality that is as per the best standards.")
            cell.updateCell(with: viewModel)
            return cell
        case ItemRatingSection.itemRatingTitle.section:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemRatingTitleCollectionViewCell.self), for: indexPath) as? ItemRatingTitleCollectionViewCell else { return UICollectionViewCell() }
            cell.updateCell(with: "Get 25 more Smiles points by rating each of your food items!")
            return cell
        case ItemRatingSection.itemRating.section:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemRatingCollectionViewCell.self), for: indexPath) as? ItemRatingCollectionViewCell else { return UICollectionViewCell() }
//            let itemToRate = viewModel.itemsToRate[indexPath.item]
            let viewModel = ItemRatingCollectionViewCell.ViewModel(itemName: "itemToRate.itemName", stars: 3.0)
            cell.updateCell(with: viewModel, delegate: self)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - ItemRatingCellActionDelegate
extension ItemRatingDataSource: ItemRatingCellActionDelegate {
    func ratingDidSelect(of item: String, with stars: Double) {        
//        viewModel.itemsToRate = viewModel.itemsToRate.map({
//            var itemToUpdate = $0
//            if itemToUpdate.itemName == item {
//                itemToUpdate.rating = stars
//            }
//            
//            return itemToUpdate
//        })
        delegate?.collectionViewShouldReload()
    }
}
