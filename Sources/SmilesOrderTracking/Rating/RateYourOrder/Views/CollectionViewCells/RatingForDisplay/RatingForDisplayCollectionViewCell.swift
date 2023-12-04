//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/12/2023.
//

import UIKit
import Cosmos
import SmilesUtilities

final class RatingForDisplayCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .lightPaigeGrayColor
        }
    }
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var informationLabel: UILabel! {
        didSet {
            informationLabel.textColor = .appGreyColor_128
            informationLabel.fontTextStyle = .smilesLabel1
        }
    }
    @IBOutlet private weak var cosmosView: CosmosView!
    @IBOutlet private weak var ratingFeedbackLabel: UILabel! {
        didSet {
            ratingFeedbackLabel.textColor = .appDarkGrayColor
            ratingFeedbackLabel.fontTextStyle = .smilesHeadline5
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 12.0)
        stackView.addshadow(top: true, left: true, bottom: true, right: true, shadowRadius: 20, offset: CGSize.zero)
        cosmosView.isUserInteractionEnabled = false
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel) {
        informationLabel.text = viewModel.informationText
        cosmosView.rating = viewModel.rating
        ratingFeedbackLabel.text = viewModel.ratingFeedback
        
        cosmosView.settings.filledImage = AppCommonMethods.getColorCodedStarImage(for: viewModel.rating)
    }
}

// MARK: - ViewModel

extension RatingForDisplayCollectionViewCell {
    struct ViewModel {
        var informationText: String?
        var rating = 0.0
        var ratingFeedback: String?
    }
}
