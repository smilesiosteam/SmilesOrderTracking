//
//  PickupConfirmationViewController.swift
//  
//
//  Created by Ahmed Naguib on 03/12/2023.
//

import UIKit
import SmilesFontsManager

final class PickupConfirmationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = OrderTrackingLocalization.confirmOrderPickup.text
            titleLabel.fontTextStyle = .smilesHeadline3
        }
    }
    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 12)
        }
    }
    @IBOutlet private weak var locationLabel: UILabel! {
        didSet {
            locationLabel.fontTextStyle = .smilesLabel2
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = OrderTrackingLocalization.refundInfo.text
            descriptionLabel.fontTextStyle = .smilesBody2
        }
    }
    @IBOutlet private weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setTitle(OrderTrackingLocalization.cancelText.text, for: .normal)
            cancelButton.setTitleColor(.appRevampPurpleMainColor, for: .normal)
            cancelButton.layer.cornerRadius = 12
            cancelButton.fontTextStyle = .smilesHeadline4
        }
    }
    @IBOutlet private weak var continueButton: UIButton! {
        didSet {
            continueButton.setTitle(OrderTrackingLocalization.continueText.text, for: .normal)
            continueButton.backgroundColor = .appRevampPurpleMainColor
            continueButton.layer.cornerRadius = 12
        }
    }
    
    // MARK: - Properties
    public var locationText: String = ""
    public var didTappedContinue: (()-> Void)?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = locationText
        view.backgroundColor = .black.withAlphaComponent(0.1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.fontTextStyle = .smilesHeadline4
        continueButton.titleLabel?.textColor = .white
        cancelButton.fontTextStyle = .smilesHeadline4
        cancelButton.titleLabel?.textColor = .appRevampPurpleMainColor
    }
    
    //MARK: - Buttons Actions
    @IBAction private func continueTapped(_ sender: Any) {
        didTappedContinue?()
        dismiss(animated: true)
    }
    
    @IBAction private func cancelTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Create
extension PickupConfirmationViewController {
    static func create() -> PickupConfirmationViewController {
        let viewController = PickupConfirmationViewController(nibName: String(describing: PickupConfirmationViewController.self), bundle: .module)
        return viewController
    }
}
