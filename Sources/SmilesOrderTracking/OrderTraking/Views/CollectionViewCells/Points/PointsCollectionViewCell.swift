//
//  PointsCollectionViewCell.swift
//
//
//  Created by Ahmed Naguib on 17/11/2023.
//

import UIKit
import SmilesFontsManager

final class PointsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pointImage: UIImageView!
    @IBOutlet private weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel) {
        detailsLabel.setAlignment()
        let text = viewModel.text ?? ""
        let combinedText = "\(viewModel.numberOfPoints) \(text)"
        let attributedString = NSMutableAttributedString(string: combinedText)
        
        let boldRange = (combinedText as NSString).range(of: "\(viewModel.numberOfPoints)")
        let boldFont = SmilesFontsManager.defaultAppFont.getFont(style: .medium, size: 16)
        attributedString.addAttributes([.font: boldFont], range: boldRange)
        
        let regularRange = (combinedText as NSString).range(of: text)
        let regularFont = SmilesFontsManager.defaultAppFont.getFont(style: .regular, size: 16)
        attributedString.addAttributes([.font: regularFont], range: regularRange)
        
        detailsLabel.attributedText = attributedString
    }
}


extension PointsCollectionViewCell {
    struct ViewModel: Equatable {
        var numberOfPoints: Int = 0
        var text: String?
    }
}
