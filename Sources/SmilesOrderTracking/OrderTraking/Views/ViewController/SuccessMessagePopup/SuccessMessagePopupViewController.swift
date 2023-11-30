//
//  SuccessMessagePopupViewController.swift
//  
//
//  Created by Shmeel Ahmed on 23/11/2023.
//

import UIKit
import SmilesUtilities

public class SuccessMessagePopupViewController: UIViewController {

    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var popupTitleContainer: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet var panDismissView: UIView!

    @IBOutlet weak var messageText: UILabel!
    
    @IBOutlet weak var descriptionMessage: UILabel!
    
    var dismissViewTranslation = CGPoint(x: 0, y: 0)
    
    var data = SuccessPopupViewModelData(message: "", primaryButtonTitle: "")
    // MARK: Lifecycle

    fileprivate func setupUI() {
        panDismissView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        panDismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        popupTitle.text = data.popupTitle
        messageText.text = data.message
        descriptionMessage.text = data.descriptionMessage
        descriptionMessage.isHidden = data.descriptionMessage?.isEmpty ?? true
        closeButton.isHidden = !data.showCloseButton
        popupTitle.isHidden = data.popupTitle?.isEmpty ?? true
        popupTitleContainer.isHidden = !data.showCloseButton && (data.popupTitle?.isEmpty ?? true)
        popupTitle.fontTextStyle = .smilesHeadline4
        messageText.fontTextStyle = .smilesHeadline2
        descriptionMessage.fontTextStyle = .smilesBody2
        
        primaryButton.setTitle(data.primaryButtonTitle, for: .normal)
        primaryButton.fontTextStyle = .smilesHeadline4
        
        roundedView.layer.cornerRadius = 12
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalPresentationStyle = .overFullScreen
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public init(popupData:SuccessPopupViewModelData) {
        self.data = popupData
        super.init(nibName: "SuccessMessagePopupViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            dismissViewTranslation = sender.translation(in: view)
            if dismissViewTranslation.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.dismissViewTranslation.y)
                })
            }
        case .ended:
            if dismissViewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            }
            else {
                dismiss(animated: true)
            }
        default:
            break
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func primaryAction(_ sender: Any) {
        dismiss(animated: true)
        data.primaryAction()
    }
    public class func showFeedbackSuccessViewController(from viewController:UIViewController){
        let vc = SuccessMessagePopupViewController(
            popupData: SuccessPopupViewModelData(
                showCloseButton: true,
                message: OrderTrackingLocalization.thankyouForFeedback.text,
                descriptionMessage: OrderTrackingLocalization.alwaysWrokingToImprove.text,
                primaryButtonTitle: OrderTrackingLocalization.backToHome.text,
                primaryAction: {
                    
                }
            )
        )
        viewController.present(vc)
    }
    
}


public struct SuccessPopupViewModelData {
    var showCloseButton = true
    var popupTitle:String?
    var message:String
    var descriptionMessage:String?
    var primaryButtonTitle:String
    var primaryAction={}
    public init(showCloseButton: Bool = true, popupTitle: String? = nil, message: String, descriptionMessage: String? = nil, primaryButtonTitle: String, primaryAction: @escaping ()->Void = {}) {
        self.showCloseButton = showCloseButton
        self.popupTitle = popupTitle
        self.message = message
        self.descriptionMessage = descriptionMessage
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryAction = primaryAction
    }
}
