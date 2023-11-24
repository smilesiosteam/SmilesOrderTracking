//
//  FreeDelivery CollectionViewCell.swift
//
//
//  Created by Ahmed Naguib on 17/11/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

protocol FreeDeliveryCollectionViewProtocol: AnyObject {
    func didTappSubscribeNow(with url: String?)
}

final class FreeDeliveryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subscribeButton: UIButton!
    @IBOutlet private weak var iconIMage: UIImageView!
    
    // MARK: - Properties
    private var viewModel = ViewModel()
    private weak var delegate: FreeDeliveryCollectionViewProtocol?
    
    // MARK: - Life Cycle
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
    
    // MARK: - Button Actions
    @IBAction func subscribeTapped(_ sender: Any) {
        delegate?.didTappSubscribeNow(with: viewModel.redirectUrl)
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel, delegate: FreeDeliveryCollectionViewProtocol) {
        self.viewModel = viewModel
        self.delegate = delegate
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subTitle
        iconIMage.setImageWithUrlString(viewModel.iconUrl ?? "")
    }
}

extension FreeDeliveryCollectionViewCell {
    struct ViewModel {
        var iconUrl: String?
        var title: String?
        var subTitle: String?
        var redirectUrl: String?
    }
}
