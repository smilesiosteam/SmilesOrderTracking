//
//  FreeDelivery CollectionViewCell.swift
//  
//
//  Created by Ahmed Naguib on 17/11/2023.
//

import UIKit
import SmilesFontsManager

final class FreeDeliveryCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subscribeButton: UIButton!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.fontTextStyle = .smilesTitle1
        subtitleLabel.fontTextStyle = .smilesBody3
        subscribeButton.fontTextStyle = .smilesTitle2
        containerView.layer.cornerRadius = 12
        subscribeButton.layer.cornerRadius = 14
        subscribeButton.backgroundColor = .clear
        subscribeButton.layer.borderWidth = 1
        subscribeButton.layer.borderColor = UIColor.white.cgColor
        subscribeButton.titleLabel?.textColor = .white
    }
    
    @IBAction func subscribeTapped(_ sender: Any) {
    }
    

}
