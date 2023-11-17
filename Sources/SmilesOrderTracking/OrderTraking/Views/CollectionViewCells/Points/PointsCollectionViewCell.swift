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
    
    // MARK: - Properties
    static let identifier = String(describing: PointsCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
    }
    
    // MARK: - Functions
    func updateCell(with points: String) {
        
        let text = OrderTrackingLocalization.points.text
        let combinedText = "\(points) \(text)"
        let attributedString = NSMutableAttributedString(string: combinedText)
        
        let boldRange = (combinedText as NSString).range(of: "\(points)")
        let boldFont = SmilesFontsManager.defaultAppFont.getFont(style: .medium, size: 16)
        attributedString.addAttributes([.font: boldFont], range: boldRange)
        
        let regularRange = (combinedText as NSString).range(of: text)
        let regularFont = SmilesFontsManager.defaultAppFont.getFont(style: .regular, size: 16)
        attributedString.addAttributes([.font: regularFont], range: regularRange)
        
        detailsLabel.attributedText = attributedString
    }
}
