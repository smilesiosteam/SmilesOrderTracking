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
        print(viewModel.isShowSupportHeader)
        
        headerStack.isHidden =  !viewModel.isShowSupportHeader
        
        switch viewModel.type {
        case .image(let imageName, let backgroundColor):
            headerImage.image = UIImage(named: imageName, in: .module, with: nil)
            containerView.backgroundColor = backgroundColor
            headerImage.isHidden = false
        case .animation(let url, let backgroundColor):
            headerImage.isHidden = true
            containerView.backgroundColor = UIColor(hex: backgroundColor)
            if let url {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: url, animationBackgroundView: containerView, removeFromSuper: false, loopMode: .loop,contentMode: .scaleAspectFill) { _ in }
            }
        }
    }
    
    func processAnimation(stop: Bool) {
        if let animationView = containerView.subviews.first(where: { $0 is LottieAnimationView }) as?  LottieAnimationView {
            stop ? animationView.pause() : animationView.play()
        }
        
    }
    
    private func configControllers() {
        dismissButton.layer.cornerRadius = 20
        supportButton.layer.cornerRadius = 20
        supportButton.setTitle(OrderTrackingLocalization.support.text, for: .normal)
        [supportButton, dismissButton].forEach({
            $0.fontTextStyle = .smilesTitle1
            $0.setTitleColor(.appRevampPurpleMainColor, for: .normal)
        })
    }
    
    func configHeader(isHidden: Bool) {
        headerStack.isHidden = isHidden
    }
}

extension ImageHeaderCollectionViewCell {
    struct ViewModel {
        var isShowSupportHeader = false
        var url: String?
        var type: CellType
    }
    
    enum CellType {
        case image(imageName: String, backgroundColor: UIColor)
        case animation(url: URL?, backgroundColor: String)
    }
}
