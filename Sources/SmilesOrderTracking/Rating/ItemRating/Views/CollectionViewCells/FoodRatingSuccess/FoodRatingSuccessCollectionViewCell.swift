//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 27/11/2023.
//

import UIKit
import LottieAnimationManager
import SmilesFontsManager
import SmilesUtilities

final class FoodRatingSuccessCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var thankYouLabel: UILabel! {
        didSet {
            thankYouLabel.fontTextStyle = .smilesHeadline3
            thankYouLabel.textColor = .appDarkGrayColor
        }
    }
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var pointsLabel: UILabel! {
        didSet {
            pointsLabel.fontTextStyle = .smilesBody3
            pointsLabel.textColor = .appDarkGrayColor
        }
    }
    @IBOutlet weak var ratingSuccessDescriptionLabel: UILabel! {
        didSet {
            ratingSuccessDescriptionLabel.fontTextStyle = .smilesBody3
            ratingSuccessDescriptionLabel.textColor = .appGreyColor_128
        }
    }
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .fullGreyColor
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAnimation()
        setupStackView()
    }
    
    // MARK: - Methods
    func updateCell(with viewModel: ViewModel) {
        thankYouLabel.text = viewModel.thankYouText
        if let pointsText = viewModel.pointsText, !pointsText.isEmpty {
            pointsLabel.text = pointsText
        } else {
            pointsLabel.isHidden = true
        }
        ratingSuccessDescriptionLabel.text = viewModel.ratingSuccessDescription
        
        configureAnimation()
        setupStackView()
    }
    
    private func setupStackView() {
        containerStackView.setCustomSpacing(33.0, after: thankYouLabel)
        containerStackView.setCustomSpacing(26.0, after: animationContainerView)
        containerStackView.setCustomSpacing(16.0, after: pointsLabel)
        containerStackView.setCustomSpacing(24.0, after: ratingSuccessDescriptionLabel)
    }
    
    private func configureAnimation() {
        LottieAnimationManager.showAnimation(onView: animationView, withJsonFileName: RatingAnimation.feedBackThumbsUp.name, removeFromSuper: false, loopMode: .loop) { _ in }
    }
}

// MARK: - ViewModel
extension FoodRatingSuccessCollectionViewCell {
    struct ViewModel {
        var thankYouText: String?
        var pointsText: String?
        var ratingSuccessDescription: String?
    }
}
