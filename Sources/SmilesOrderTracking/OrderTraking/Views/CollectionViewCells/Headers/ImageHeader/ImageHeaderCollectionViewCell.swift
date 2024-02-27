//
//  ImageHeaderCollectionViewCell.swift
//  
//
//  Created by Ahmed Naguib on 15/11/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities
import LottieAnimationManager
import Lottie

protocol HeaderCollectionViewProtocol: AnyObject {
    func didTappDismiss()
    func didTappSupport()
}

final class ImageHeaderCollectionViewCell: UICollectionReusableView {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var supportButton: UIButton!
    @IBOutlet private weak var headerStack: UIStackView!
    @IBOutlet private weak var headerImage: UIImageView!
    
    private weak var delegate: HeaderCollectionViewProtocol?
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configControllers()
        containerView.backgroundColor = .purple
    }
    
    // MARK: - Button Actions
    @IBAction private func dismissButtonTapped(_ sender: Any) {
        delegate?.didTappDismiss()
    }
    
    @IBAction private func supportButtonTapped(_ sender: Any) {
        delegate?.didTappSupport()
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel, delegate: HeaderCollectionViewProtocol) {
        self.delegate = delegate
        
        headerStack.isHidden =  !viewModel.isShowSupportHeader
        animationView?.removeFromSuperview()
        switch viewModel.type {
        case .image(let imageName, let backgroundColor):
            headerImage.image = UIImage(named: imageName, in: .module, with: nil)
            containerView.backgroundColor = backgroundColor
            headerImage.isHidden = false
        case .animation(let url, let backgroundColor):
            
            headerImage.isHidden = true
            containerView.backgroundColor = UIColor(hex: backgroundColor)
            containerView.backgroundColor = .white
            if let url {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: url, animationBackgroundView: containerView, removeFromSuper: false, loopMode: .loop,contentMode: .scaleAspectFill) { _ in }
            }
        }
    }
    
    func processAnimation(stop: Bool) {
        if let animationView {
            stop ? animationView.pause() : animationView.play()
        }
    }
    
    private var animationView: LottieAnimationView? {
        containerView.subviews.first(where: { $0 is LottieAnimationView }) as?  LottieAnimationView
    }
    
    private func configControllers() {
        dismissButton.layer.cornerRadius = 20
        supportButton.layer.cornerRadius = 20
        supportButton.setTitle(OrderTrackingLocalization.support.text, for: .normal)
        supportButton.addShadowToSelf(
            offset: CGSize(width: 0, height: 2),
            color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.12),
            radius: 8.0,
            opacity: 1)
        [supportButton].forEach({
            $0.fontTextStyle = .smilesTitle1
            $0.setTitleColor(.appRevampPurpleMainColor, for: .normal)
        })
    }
    
    func configHeader(isHidden: Bool) {
        headerStack.isHidden = isHidden
    }
}

extension ImageHeaderCollectionViewCell {
    struct ViewModel: Equatable {
        var isShowSupportHeader = false
        var type: CellType
    }
    
    enum CellType: Equatable {
        case image(imageName: String, backgroundColor: UIColor)
        case animation(url: URL?, backgroundColor: String)
    }
}
