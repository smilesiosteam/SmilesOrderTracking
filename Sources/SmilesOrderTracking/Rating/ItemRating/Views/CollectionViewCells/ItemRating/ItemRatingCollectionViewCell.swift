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
    func ratingDidSelect(of item: String, with stars: Double)
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
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        ratingStarView.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel, delegate: ItemRatingCellActionDelegate) {
        self.delegate = delegate
        
        itemNameLabel.text = viewModel.itemName
        configureStarsState(with: viewModel)
    }
    
    private func configureStarsState(with viewModel: ViewModel) {
        ratingStarView.rating = viewModel.stars ?? 0.0
        ratingStarView.didFinishTouchingCosmos = { [weak self] stars in
            guard let self else { return }
            let ratingState = RatingStar.count(stars).state
            self.ratingStarView.settings.filledImage = UIImage(resource: ratingState.icon)
            self.ratingTextLabel.text = ratingState.text
            self.ratingTextLabel.isHidden = false
            self.delegate?.ratingDidSelect(of: viewModel.itemName.asStringOrEmpty(), with: stars)
        }
    }
}

// MARK: - ViewModel
extension ItemRatingCollectionViewCell {
    struct ViewModel {
        var itemName: String?
        var stars: Double?
    }
}
