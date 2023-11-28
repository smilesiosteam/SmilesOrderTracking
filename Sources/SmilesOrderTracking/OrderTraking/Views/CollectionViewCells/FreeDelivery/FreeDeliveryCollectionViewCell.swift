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
    func didTappSubscribeNow()
}

final class FreeDeliveryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var subscriptionImage: UIImageView!
    
    // MARK: - Properties
    private var viewModel = ViewModel()
    private weak var delegate: FreeDeliveryCollectionViewProtocol?
    
    // MARK: - Button Actions
    @IBAction func subscribeTapped(_ sender: Any) {
        delegate?.didTappSubscribeNow()
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel, delegate: FreeDeliveryCollectionViewProtocol) {
        self.delegate = delegate
        subscriptionImage.setImageWithUrlString(viewModel.imageURL ?? "")
    }
}

extension FreeDeliveryCollectionViewCell {
    struct ViewModel {
        var imageURL: String?
    }
}
