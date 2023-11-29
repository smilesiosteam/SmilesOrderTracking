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
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.fontTextStyle = .smilesHeadline4
        subtitleLabel.fontTextStyle = .smilesBody3
        containerView.layer.cornerRadius = 12
    }
    
    func updateCell(with viewModel: ViewModel) {
        
    }
}

extension CashCollectionViewCell {
    struct ViewModel {
        
    }
}
