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
            return viewModel.itemRatingUIModel.orderItems.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case ItemRatingSection.ratingSuccess.section:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FoodRatingSuccessCollectionViewCell.self), for: indexPath) as? FoodRatingSuccessCollectionViewCell else { return UICollectionViewCell() }
            let ratingOrderResult = viewModel.itemRatingUIModel.ratingOrderResponse.ratingOrderResult
            let viewModel = FoodRatingSuccessCollectionViewCell.ViewModel(thankYouText: viewModel.popupTitle, pointsText: ratingOrderResult?.accrualTitle, ratingSuccessDescription: ratingOrderResult?.description)
            cell.updateCell(with: viewModel)
            return cell
        case ItemRatingSection.itemRatingTitle.section:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemRatingTitleCollectionViewCell.self), for: indexPath) as? ItemRatingTitleCollectionViewCell else { return UICollectionViewCell() }
            let ratingOrderResult = viewModel.itemRatingUIModel.ratingOrderResponse.ratingOrderResult
            cell.updateCell(with: ratingOrderResult?.accrualDescription)
            return cell
        case ItemRatingSection.itemRating.section:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemRatingCollectionViewCell.self), for: indexPath) as? ItemRatingCollectionViewCell else { return UICollectionViewCell() }
            let itemToRate = viewModel.itemRatingUIModel.orderItems[indexPath.item]
            var viewModel = ItemRatingCollectionViewCell.ViewModel(itemName: itemToRate.itemName, itemId: itemToRate.itemID, rating: itemToRate.userItemRating ?? 0.0, ratingArray: itemToRate.rating, itemImage: itemToRate.itemImage)
            
            // TODO: Check flow of this check against old implementation in ThankyouForRatingPresenter
            if itemToRate.userItemRating ?? 0.0 > 0 {
                viewModel.enableStarsInteraction = false
                self.viewModel.doneActionDismiss = true
            } else {
                self.viewModel.doneActionDismiss = false
            }
            cell.updateCell(with: viewModel, delegate: self)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - ItemRatingCellActionDelegate
extension ItemRatingDataSource: ItemRatingCellActionDelegate {
    func didTapRating(with ratingNumber: Int, ratingType: String?) {
        
    }
    
    func updateItemData(with itemRating: ItemRatings, orderRating: OrderRatingModel, ratingType: String?) {
        if let index = viewModel.itemRatings.firstIndex(where: { $0.itemId == itemRating.itemId }) {
            viewModel.itemRatings[index] = itemRating
        } else {
            viewModel.itemRatings.append(itemRating)
        }
    }
}
