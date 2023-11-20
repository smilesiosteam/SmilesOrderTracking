//
//  ImageHeaderCollectionViewCell.swift
//  
//
//  Created by Ahmed Naguib on 15/11/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

protocol HeaderCollectionViewProtocol: AnyObject {
    func didTappDismiss()
    func didTappSupport()
}

final class ImageHeaderCollectionViewCell: UICollectionReusableView {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var supportButton: UIButton!
    @IBOutlet weak var headerStack: UIStackView!
    
    static let identifier = String(describing: ImageHeaderCollectionViewCell.self)
    
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
    func updateCell(with viewModel: ViewModel) {
//        self.delegate = delegate
        headerStack.isHidden = !viewModel.isShowSupportHeader
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
}

extension ImageHeaderCollectionViewCell {
    struct ViewModel {
        var isShowSupportHeader = false
        var url: String?
    }
}
