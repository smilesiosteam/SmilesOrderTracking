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
import SDWebImage

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
    @IBOutlet weak var ratingTextLabelContainerView: UIView!
    @IBOutlet weak var ratingTextLabel: UILabel! {
        didSet {
            ratingTextLabel.fontTextStyle = .smilesHeadline4
            ratingTextLabel.textColor = .appDarkGrayColor
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
        
        ratingArray = viewModel.ratingArray
        ratingType = viewModel.ratingType
        itemStarImageView.setImageWithUrlString(viewModel.itemImage.asStringOrEmpty())
        
        let rating = viewModel.rating > 0.0 ? viewModel.rating : viewModel.ratingCount
        ratingTextLabel.text = viewModel.ratingSubtitle
        ratingTextLabelContainerView.isHidden = rating > 0.0 ? false : true
        ratingStarView.rating = rating
        ratingStarView.settings.filledImage = AppCommonMethods.getColorCodedStarImage(for: rating)
        
        if (viewModel.rating > 0) && !(viewModel.enableStarsInteraction) {
            ratingStarView.rating = viewModel.rating
            ratingStarView.isUserInteractionEnabled = false
        } else {
            ratingStarView.isUserInteractionEnabled = true
        }
    }
    
    private func configureStarsState(with rating: Double) {
        ratingTextLabelContainerView.isHidden = false
        let ratingObj = self.ratingArray?[safe: Int(rating) - 1]
        self.viewModel?.rating = Double(rating)
        
        SDWebImageManager.shared.loadImage(with: URL(string: ratingObj?.ratingImage ?? ""), options: .continueInBackground, progress: nil) { image, data, error, _, _, _ in
            DispatchQueue.main.async {
                self.ratingStarView.settings.filledImage = image
            }
        }
        
        ratingTextLabel.text = ratingObj?.ratingFeedback
        
        let itemData = createItemRatingObj(userRating: Double(rating), itemId: ratingObj?.id ?? 0 , ratingFeedback: ratingObj?.ratingFeedback ?? "")
        let ratingData = createRatingObj(userRating: Double(rating), ratingType: self.ratingType ?? "", ratingFeedback: ratingObj?.ratingFeedback ?? "")
        
        self.delegate?.updateItemData(with: itemData, orderRating: ratingData, ratingType: self.ratingType)
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
        var ratingCount = 0.0
    }
}
