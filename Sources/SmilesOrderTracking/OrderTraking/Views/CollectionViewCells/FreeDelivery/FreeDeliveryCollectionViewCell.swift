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
    func didTappSubscribe(with url: String)
}

final class FreeDeliveryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var subscriptionImage: UIImageView!
    
    // MARK: - Properties
    private var viewModel = ViewModel()
    private weak var delegate: FreeDeliveryCollectionViewProtocol?
    
    // MARK: - Button Actions
    @IBAction func subscribeTapped(_ sender: Any) {
        delegate?.didTappSubscribe(with: viewModel.redirectUrl)
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel, delegate: FreeDeliveryCollectionViewProtocol) {
        self.delegate = delegate
        self.viewModel = viewModel
        subscriptionImage.setImageWithUrlString(viewModel.imageURL ?? "")
    }
}

extension FreeDeliveryCollectionViewCell {
    struct ViewModel: Equatable {
        var imageURL: String?
        var redirectUrl: String = ""
    }
}
