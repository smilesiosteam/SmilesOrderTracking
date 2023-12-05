//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/12/2023.
//

import UIKit
import SmilesUtilities

final class SeparatorLineCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .searchBarColor
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
