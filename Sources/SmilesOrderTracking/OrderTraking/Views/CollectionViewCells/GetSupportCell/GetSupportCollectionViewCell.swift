//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 16/11/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

protocol GetSupportCollectionViewCellActionDelegate: AnyObject {
    func didClick(_:GetSupportCollectionViewCell.ViewModel)
}

final class GetSupportCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var titleStackView: UIStackView!
    var delegate:GetSupportCollectionViewCellActionDelegate?
    
    var onClickContainer = {}
    
    @IBOutlet weak var containerTopPadding: NSLayoutConstraint!
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.fontTextStyle = .smilesHeadline3
            titleLabel.textColor = .black
            titleLabel.setAlignment()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTap)))
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet private weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.fontTextStyle = .smilesBody3
            subtitleLabel.textColor = .black.withAlphaComponent(0.5)
            subtitleLabel.setAlignment()
        }
    }
    
    
    // MARK: - Properties
//    private weak var delegate: OrderConfirmationCellActionDelegate?
    private var viewModel = ViewModel()
        
    // MARK: - Methods
    @objc func onTap(){
        onClickContainer()
    }
    func updateCell(with viewModel: ViewModel, delegate: GetSupportCollectionViewCellActionDelegate) {
        self.delegate = delegate
        onClickContainer = {[viewModel] in
            delegate.didClick(viewModel)
        }
        subtitleLabel.text = viewModel.type.subtitle()
        titleLabel.text = viewModel.type.title()
        containerTopPadding.constant = viewModel.type == .openFAQ ? 48 : 0
        iconView.image = UIImage(named: viewModel.type.iconName(), in: .module, with: nil)
    }
}

// MARK: - ViewModel
extension GetSupportCollectionViewCell {
    struct ViewModel {
        var type: SmilesSupportActionType = .liveChat
        var order:OrderDetail?
    }
}
