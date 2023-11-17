//
//  CashCollectionViewCell.swift
//  
//
//  Created by Ahmed Naguib on 17/11/2023.
//

import UIKit
import SmilesFontsManager

final class CashCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    static let identifier = String(describing: CashCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.fontTextStyle = .smilesHeadline4
        subtitleLabel.fontTextStyle = .smilesBody3
        containerView.layer.cornerRadius = 12
    }

}
