//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 28/11/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

final class ItemRatingTitleCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.fontTextStyle = .smilesBody3
            titleLabel.textColor = .appDarkGrayColor
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods
    func updateCell(with message: String?) {
        titleLabel.text = message
    }
}
