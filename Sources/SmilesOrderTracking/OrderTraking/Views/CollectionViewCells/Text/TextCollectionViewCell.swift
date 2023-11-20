//
//  TextCollectionViewCell.swift
//  
//
//  Created by Ahmed Naguib on 16/11/2023.
//

import UIKit

final class TextCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak private var detailsLable: UILabel!
    
    static let identifier = String(describing: TextCollectionViewCell.self)
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsLable.fontTextStyle = .smilesBody2
        detailsLable.textColor = .black.withAlphaComponent(0.8)
    }
    
    func updateCell(with details: String) {
        detailsLable.text = details
    }
}
