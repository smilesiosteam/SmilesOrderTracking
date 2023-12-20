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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsLable.fontTextStyle = .smilesBody3
        detailsLable.textColor = .black.withAlphaComponent(0.8)
    }
    
    func updateCell(with viewModel: ViewModel) {
        detailsLable.text = viewModel.title
        detailsLable.fontTextStyle = viewModel.type.style
        detailsLable.setAlignment()
    }
}

extension TextCollectionViewCell {
    struct ViewModel: Equatable {
        var title: String?
        var type: FontType = .subTitle
    }
    
    enum FontType: Equatable {
        case title
        case subTitle
        
        var style: UIFont.TextStyle {
            switch self {
            case .title:
                return .smilesHeadline2
            case .subTitle:
                return .smilesBody3
            }
        }
    }
}
