//
//  GetSupportImageHeaderCollectionViewCell.swift
//  
//
//  Created by Shmeel Ahmad on 06/12/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities
import LottieAnimationManager
import Lottie

protocol GetSupportHeaderCollectionViewProtocol: AnyObject {
    func didTapBack()
}

final class GetSupportImageHeaderCollectionViewCell: UICollectionReusableView {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var headerImage: UIImageView!
    
    private weak var delegate: GetSupportHeaderCollectionViewProtocol?
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Button Actions
    @IBAction private func dismissButtonTapped(_ sender: Any) {
        delegate?.didTapBack()
    }
    
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel, delegate: GetSupportHeaderCollectionViewProtocol) {
        self.delegate = delegate
        switch viewModel.type {
        case .image(let imageName):
            headerImage.image = UIImage(named: imageName, in: .module, with: nil)
        case .animation(let url):
            if let url {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: url, animationBackgroundView: headerImage, removeFromSuper: false, loopMode: .loop,contentMode: .scaleAspectFill) { _ in }
            }
        }
    }
    
    func processAnimation(stop: Bool) {
        if let animationView = containerView.subviews.first(where: { $0 is LottieAnimationView }) as?  LottieAnimationView {
            stop ? animationView.pause() : animationView.play()
        }
        
    }

    
}

extension GetSupportImageHeaderCollectionViewCell {
    struct ViewModel {
        var url: String?
        var type: CellType
    }
    
    enum CellType {
        case image(imageName: String)
        case animation(url: URL?)
    }
}
