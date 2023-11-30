//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 28/11/2023.
//

import UIKit
import Cosmos
import SmilesUtilities
import SmilesFontsManager

protocol ItemRatingCellActionDelegate: AnyObject {
    func didTapRating(with ratingNumber: Int, ratingType: String?)
    func updateItemData(with itemRating: ItemRatings, orderRating: OrderRatingModel, ratingType: String?)
}

final class ItemRatingCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var itemStarView: UIView!
    @IBOutlet weak var itemStarImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel! {
        didSet {
            itemNameLabel.fontTextStyle = .smilesBody3
            itemNameLabel.textColor = .appDarkGrayColor
        }
    }
    @IBOutlet weak var ratingStarView: CosmosView!
    @IBOutlet weak var ratingTextLabel: UILabel! {
        didSet {
            ratingTextLabel.fontTextStyle = .smilesHeadline4
            ratingTextLabel.textColor = .appDarkGrayColor
            ratingTextLabel.isHidden = true
        }
    }
    
    // MARK: - Properties
    weak var delegate: ItemRatingCellActionDelegate?
    private var ratingArray: [Rating]?
    private var ratingType: String?
    private var itemRatings: [ItemRatings]?
    private var itemId = ""
    private var viewModel: ViewModel?
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        ratingStarView.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingStarView.settings.fillMode = .full
        ratingStarView.didFinishTouchingCosmos = { [weak self] stars in
            guard let self else { return }
            self.configureStarsState(with: stars)
            self.delegate?.didTapRating(with: Int(stars), ratingType: self.ratingType)
        }
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel, delegate: ItemRatingCellActionDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        
        itemId = viewModel.itemId.asStringOrEmpty()
        itemNameLabel.text = viewModel.itemName
        ratingTextLabel.text = viewModel.ratingSubtitle
        ratingStarView.rating = viewModel.rating
        ratingArray = viewModel.ratingArray
        ratingType = viewModel.ratingType
        itemStarImageView.setImageWithUrlString(viewModel.itemImage.asStringOrEmpty())
        ratingStarView.settings.filledImage = AppCommonMethods.getColorCodedStarImage(for: ratingStarView.rating)
        
        if (viewModel.rating > 0) && !(viewModel.enableStarsInteraction) {
            ratingStarView.rating = viewModel.rating
            ratingStarView.isUserInteractionEnabled = false
        } else {
            ratingStarView.isUserInteractionEnabled = true
        }
    }
    
    private func configureStarsState(with rating: Double) {
        self.ratingTextLabel.isHidden = false
        let ratingObj = self.ratingArray?[safe: Int(rating) - 1]
        self.viewModel?.rating = Double(rating)
        switch rating {
        case 1:
            ratingTextLabel.text = ratingObj?.ratingFeedback
            ratingStarView.settings.filledImage = UIImage(url: URL(string: ratingObj?.ratingImage ?? ""))

            let itemData = createItemRatingObj(userRating: Double(rating), itemId: ratingObj?.id ?? 0 , ratingFeedback: ratingObj?.ratingFeedback ?? "")
            let ratingData = createRatingObj(userRating: Double(rating), ratingType: self.ratingType ?? "", ratingFeedback: ratingObj?.ratingFeedback ?? "")
            
            self.delegate?.updateItemData(with: itemData, orderRating: ratingData, ratingType: self.ratingType)
            
        case 2:
            ratingTextLabel.text = ratingObj?.ratingFeedback
            ratingStarView.settings.filledImage = UIImage(url: URL(string: ratingObj?.ratingImage ?? ""))

            let itemData = createItemRatingObj(userRating: Double(rating), itemId: ratingObj?.id ?? 0 , ratingFeedback: ratingObj?.ratingFeedback ?? "")
            let ratingData = createRatingObj(userRating: Double(rating), ratingType: self.ratingType ?? "", ratingFeedback: ratingObj?.ratingFeedback ?? "")

            self.delegate?.updateItemData(with: itemData, orderRating: ratingData, ratingType: self.ratingType)
        case 3:
            ratingTextLabel.text = ratingObj?.ratingFeedback
            ratingStarView.settings.filledImage = UIImage(url: URL(string: ratingObj?.ratingImage ?? ""))

            let itemData = createItemRatingObj(userRating: Double(rating), itemId: ratingObj?.id ?? 0 , ratingFeedback: ratingObj?.ratingFeedback ?? "")
            let ratingData = createRatingObj(userRating: Double(rating), ratingType: self.ratingType ?? "", ratingFeedback: ratingObj?.ratingFeedback ?? "")

            self.delegate?.updateItemData(with: itemData, orderRating: ratingData, ratingType: self.ratingType)

        case 4:
            ratingTextLabel.text = ratingObj?.ratingFeedback
            ratingStarView.settings.filledImage = UIImage(url: URL(string: ratingObj?.ratingImage ?? ""))

            let itemData = createItemRatingObj(userRating: Double(rating), itemId: ratingObj?.id ?? 0 , ratingFeedback: ratingObj?.ratingFeedback ?? "")
            let ratingData = createRatingObj(userRating: Double(rating), ratingType: self.ratingType ?? "", ratingFeedback: ratingObj?.ratingFeedback ?? "")

            self.delegate?.updateItemData(with: itemData, orderRating: ratingData, ratingType: self.ratingType)

        case 5:
            ratingTextLabel.text = ratingObj?.ratingFeedback
            ratingStarView.settings.filledImage = UIImage(url: URL(string: ratingObj?.ratingImage ?? ""))

            let itemData = createItemRatingObj(userRating: Double(rating), itemId: ratingObj?.id ?? 0 , ratingFeedback: ratingObj?.ratingFeedback ?? "")
            let ratingData = createRatingObj(userRating: Double(rating), ratingType: self.ratingType ?? "", ratingFeedback: ratingObj?.ratingFeedback ?? "")

            self.delegate?.updateItemData(with: itemData, orderRating: ratingData, ratingType: self.ratingType)

        default:
            break
        }
    }
    
    private func createItemRatingObj(userRating: Double, itemId: Int, ratingFeedback: String) -> ItemRatings {
        let model = ItemRatings()
        model.itemId = self.itemId
        model.userRating = userRating
        model.ratingFeedback = ratingFeedback
        return model
    }
    
    private func createRatingObj(userRating: Double, ratingType: String, ratingFeedback: String) -> OrderRatingModel {
        let model = OrderRatingModel()
        model.userRating = userRating
        model.ratingType = ratingType
        model.ratingFeedback = ratingFeedback
        return model
    }
}

// MARK: - ViewModel
extension ItemRatingCollectionViewCell {
    struct ViewModel {
        var itemName: String?
        var itemId: String?
        var rating = 0.0
        var ratingSubtitle: String?
        var ratingArray: [Rating]?
        var itemImage: String?
        var ratingType: String?
        var userRating: Double?
        var enableStarsInteraction = true
    }
}
