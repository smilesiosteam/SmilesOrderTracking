//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 28/11/2023.
//

import UIKit
import Combine

protocol ItemRatingDataSourceDelegate: AnyObject {
    func collectionViewShouldReloadRow(at index: Int)
}

final class ItemRatingDataSource: NSObject {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: ItemRatingViewModel
    weak var delegate: ItemRatingDataSourceDelegate?
    
    private var sections = [ItemRatingSection]()
    
    private var stateSubject: PassthroughSubject<State, Never> = .init()
    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Lifecycle
    init(viewModel: ItemRatingViewModel) {
        self.viewModel = viewModel
        
        super.init()
        createSections()
    }
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            // Size
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(200.0)
            )
            
            // Item
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                subitems: [item]
            )
//            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
            section.interGroupSpacing = 16
            
            return section
        }
    }
    
    private func createSections() {
        sections.append(.ratingSuccess)
        if let accrualDescription = viewModel.itemRatingUIModel.ratingOrderResponse.ratingOrderResult?.accrualDescription, !accrualDescription.isEmpty {
            sections.append(.itemRatingTitle)
        }
        sections.append(.itemRating)
    }
    
    private func getSection(forSection: Int) -> ItemRatingSection {
        return sections[forSection]
    }
}

extension ItemRatingDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch getSection(forSection: section) {
        case .ratingSuccess:
            return 1
        case .itemRatingTitle:
            return 1
        case .itemRating:
            return viewModel.itemRatingUIModel.orderItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch getSection(forSection: indexPath.section) {
        case .ratingSuccess:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FoodRatingSuccessCollectionViewCell.self), for: indexPath) as? FoodRatingSuccessCollectionViewCell else { return UICollectionViewCell() }
            let ratingOrderResult = viewModel.itemRatingUIModel.ratingOrderResponse.ratingOrderResult
            let viewModel = FoodRatingSuccessCollectionViewCell.ViewModel(thankYouText: viewModel.popupTitle, pointsText: ratingOrderResult?.accrualTitle, ratingSuccessDescription: ratingOrderResult?.description)
            
            cell.updateCell(with: viewModel)
            return cell
        case .itemRatingTitle:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemRatingTitleCollectionViewCell.self), for: indexPath) as? ItemRatingTitleCollectionViewCell else { return UICollectionViewCell() }
            let ratingOrderResult = viewModel.itemRatingUIModel.ratingOrderResponse.ratingOrderResult
            
            cell.updateCell(with: ratingOrderResult?.accrualDescription)
            return cell
        case .itemRating:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemRatingCollectionViewCell.self), for: indexPath) as? ItemRatingCollectionViewCell else { return UICollectionViewCell() }
            let itemToRate = viewModel.itemRatingUIModel.orderItems[indexPath.row]
            var viewModel = ItemRatingCollectionViewCell.ViewModel(itemName: itemToRate.itemName, itemId: itemToRate.itemID, rating: itemToRate.userItemRating ?? 0.0, ratingSubtitle: itemToRate.ratingFeedback, ratingArray: itemToRate.rating, itemImage: itemToRate.itemImage, ratingCount: itemToRate.ratingCount)
            
            if itemToRate.userItemRating ?? 0.0 > 0 {
                viewModel.enableStarsInteraction = false
                self.viewModel.doneActionDismiss = true
            } else {
                self.viewModel.doneActionDismiss = false
            }
            
            cell.updateCell(with: viewModel, delegate: self)
            return cell
        }
    }
}

// MARK: - ItemRatingCellActionDelegate
extension ItemRatingDataSource: ItemRatingCellActionDelegate {
    func didTapRating(with ratingNumber: Int, ratingType: String?) {}
    
    func updateItemData(with itemRating: ItemRatings, orderRating: OrderRatingModel, ratingType: String?) {
        stateSubject.send(.enableDoneButton(enable: true))
        
        viewModel.itemRatingUIModel.orderItems = viewModel.itemRatingUIModel.orderItems.map {
            var item = $0
            if $0.itemID == itemRating.itemId {
                item.ratingCount = itemRating.userRating ?? 0.0
                item.ratingFeedback = itemRating.ratingFeedback
            }
            
            return item
        }
        
        if let index = viewModel.itemRatings.firstIndex(where: { $0.itemId == itemRating.itemId }) {
            viewModel.itemRatings[index] = itemRating
        } else {
            viewModel.itemRatings.append(itemRating)
        }
        
        if let index = viewModel.itemRatingUIModel.orderItems.firstIndex(where: { $0.itemID == itemRating.itemId }) {
            delegate?.collectionViewShouldReloadRow(at: index)
        }
    }
}

extension ItemRatingDataSource {
    enum State {
        case enableDoneButton(enable: Bool)
    }
}
