//
//  ImageHeaderCollectionViewCell.swift
//  
//
//  Created by Ahmed Naguib on 15/11/2023.
//

import UIKit

final class ImageHeaderCollectionViewCell: UICollectionReusableView {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var supportButton: UIButton!
    
    static let identifier = String(describing: ImageHeaderCollectionViewCell.self)
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configControllers()
    }
    
    private func configControllers() {
        dismissButton.layer.cornerRadius = 20
        supportButton.layer.cornerRadius = 20
        supportButton.setTitle(OrderTrackingLocalization.support.text, for: .normal)
        
    }
    
    // MARK: - Button Actions
    @IBAction private func dismissButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction private func supportButtonTapped(_ sender: Any) {
        
    }
}
