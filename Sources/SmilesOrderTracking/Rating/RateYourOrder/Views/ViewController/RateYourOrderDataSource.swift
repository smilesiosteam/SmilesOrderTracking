//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/12/2023.
//

import UIKit
import Combine

protocol RateYourOrderDataSourceDelegate: AnyObject {
    func collectionViewShouldReloadRow(at index: Int, section: RateYourOrderSection)
}

final class RateYourOrderDataSource: NSObject {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: RateYourOrderViewModel
    weak var delegate: RateYourOrderDataSourceDelegate?
    
    @Published var enableDoneButton = false
    private var sections = [RateYourOrderSection]()
    
    // MARK: - Lifecycle
    init(viewModel: RateYourOrderViewModel) {
        self.viewModel = viewModel
        super.init()
        
        if let orderRating = viewModel.rateYourOrderUIModel.ratingOrderResponse.orderRating, !orderRating.isEmpty {
            viewModel.orderRatings = orderRating
            makeItemsForRating(with: orderRating)
        }
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
//            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 23, trailing: 0)
            section.interGroupSpacing = 16
            section.contentInsets = .init(top: 0, leading: 0, bottom: 24, trailing: 0)
            
            return section
        }
    }
    
    private func makeItemsForRating(with model: [OrderRating]) {
        for i in 1...model.count {
            if let ratingObj = model[safe: i] {
                if ratingObj.userRating ?? 0 > 0 {
                    viewModel.isAnyRatingGiven = true
                    if ratingObj.ratingType == "food" {
                        viewModel.lastHighestFoodValue = ratingObj.userRating ?? 0
                    } else {
                        viewModel.lastHighestDeliveryValue = ratingObj.userRating ?? 0
                    }
                }
                
                viewModel.orderRatingsItems.append(ratingObj)
            }
        }
    }
    
    private func updateTopCellOnBasisOfRating(rating: Int, ratingType: String) {
        let dValue = viewModel.parityCheckNumber
        viewModel.orderRatings[0].userRating = dValue
        
        delegate?.collectionViewShouldReloadRow(at: 0, section: .ratingForDisplay)
    }
    
    private func createSections() {
        if !viewModel.orderRatings.isEmpty {
            sections.append(.ratingForDisplay)
            sections.append(.itemRating)
            sections.append(.separatorLine)
        }
        
        sections.append(.describeOrderExperience)
    }
    
    private func getSection(forSection: Int) -> RateYourOrderSection {
        return sections[forSection]
    }
}

extension RateYourOrderDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch getSection(forSection: section) {
        case .ratingForDisplay:
            return 1
        case .itemRating:
            return viewModel.orderRatingsItems.count
        case .separatorLine:
            return 1
        case .describeOrderExperience:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch getSection(forSection: indexPath.section) {
        case .ratingForDisplay:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RatingForDisplayCollectionViewCell.self), for: indexPath) as? RatingForDisplayCollectionViewCell else { return UICollectionViewCell() }
            
            let itemToDisplay = viewModel.orderRatings[safe: 0]
            var viewModel = RatingForDisplayCollectionViewCell.ViewModel(informationText: itemToDisplay?.title)
            if let nRating = itemToDisplay?.userRating, nRating > 0 {
                viewModel.rating = Double(nRating)
                viewModel.ratingFeedback = itemToDisplay?.rating?[nRating - 1].ratingFeedback
            } else {
                viewModel.rating = 0.0
            }
            
            cell.updateCell(with: viewModel)
            return cell
        case .itemRating:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemRatingCollectionViewCell.self), for: indexPath) as? ItemRatingCollectionViewCell else { return UICollectionViewCell() }
            
            let itemToRate = viewModel.orderRatingsItems[indexPath.row]
            var viewModel = ItemRatingCollectionViewCell.ViewModel(itemName: itemToRate.title, ratingSubtitle: itemToRate.ratingFeedback ?? "", ratingArray: itemToRate.rating, itemImage: itemToRate.image, ratingType: itemToRate.ratingType, ratingCount: itemToRate.ratingCount)
            if let nRating = itemToRate.userRating, nRating > 0 {
                viewModel.rating = Double(nRating)
                viewModel.enableStarsInteraction = false
            } else {
                viewModel.rating = 0.0
            }
            
            cell.updateCell(with: viewModel, delegate: self)
            return cell
        case .separatorLine:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SeparatorLineCollectionViewCell.self), for: indexPath) as? SeparatorLineCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        case .describeOrderExperience:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DescribeOrderExperienceCollectionViewCell.self), for: indexPath) as? DescribeOrderExperienceCollectionViewCell else { return UICollectionViewCell() }
            
            let viewModel = DescribeOrderExperienceCollectionViewCell.ViewModel(placeholderText: OrderTrackingLocalization.describeYourExperience.text)
            cell.updateCell(with: viewModel, delegate: self)
            return cell
        }
    }
}

// MARK: - ItemRatingCellActionDelegate
extension RateYourOrderDataSource: ItemRatingCellActionDelegate {
    func didTapRating(with ratingNumber: Int, ratingType: String?) {
        //do rating comparison here...
        if ratingType == "delivery" {
            viewModel.lastHighestDeliveryValue = ratingNumber
        }
        
        if ratingType == "food" {
            viewModel.lastHighestFoodValue = ratingNumber
        }
        
        if viewModel.lastHighestDeliveryValue > viewModel.lastHighestFoodValue {
            viewModel.parityCheckNumber = viewModel.lastHighestDeliveryValue
        } else {
            viewModel.parityCheckNumber = viewModel.lastHighestFoodValue
        }
        
        self.updateTopCellOnBasisOfRating(rating: ratingNumber, ratingType: ratingType ?? "")
    }
    
    func updateItemData(with itemRating: ItemRatings, orderRating: OrderRatingModel, ratingType: String?) {
        viewModel.orderRatingsItems = viewModel.orderRatingsItems.map {
            var item = $0
            if $0.ratingType == orderRating.ratingType {
                item.ratingCount = orderRating.userRating ?? 0.0
                item.ratingFeedback = orderRating.ratingFeedback
            }
            
            return item
        }
        
        if let index = viewModel.orderRatingsItems.firstIndex(where: { $0.ratingType == orderRating.ratingType }) {
            viewModel.itemRatings[index] = itemRating
            viewModel.orderRatingModels[index] = orderRating
        } else {
            viewModel.itemRatings.append(itemRating)
            viewModel.orderRatingModels.append(orderRating)
        }
        
        if viewModel.isAnyRatingGiven {
            enableDoneButton = true
        } else {
            if !viewModel.orderRatings.isEmpty {
                if viewModel.itemRatings.count == viewModel.orderRatings.count - 1 {
                    enableDoneButton = true
                } else {
                    enableDoneButton = false
                }
            }
        }
        
        if let index = viewModel.orderRatingsItems.firstIndex(where: { $0.ratingType == orderRating.ratingType }) {
            delegate?.collectionViewShouldReloadRow(at: index, section: .itemRating)
        }
    }
}

// MARK: - DescribeOrderExperienceCellDelegate
extension RateYourOrderDataSource: DescribeOrderExperienceCellDelegate {
    func textViewDidEndTyping(_ text: String?) {
        if let feedbackText = text, !feedbackText.isEmpty {
            viewModel.userFeedbackText = feedbackText
        }
    }
}

