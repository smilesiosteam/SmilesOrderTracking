//
//  SmilesOrderCancelledViewController.swift
//  
//
//  Created by Shmeel Ahmed on 20/11/2023.
//

import UIKit
import SmilesUtilities

public class SmilesOrderCancelledViewController: UIViewController {

    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var popupTitleContainer: UIView!
    
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet var panDismissView: UIView!

    @IBOutlet weak var messageText: UILabel!
    
    @IBOutlet weak var descriptionMessage: UILabel!
    var submitAction: ()->Void = {}
    var supportAction: ()->Void = {}
    var dismissViewTranslation = CGPoint(x: 0, y: 0)
    
    // MARK: Lifecycle

    fileprivate func setupUI() {
        panDismissView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        panDismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        messageText.text = "Your order has been cancelled".localizedString
        descriptionMessage.text = "Please let us know why you need to cancel your order".localizedString
        messageText.fontTextStyle = .smilesHeadline2
        descriptionMessage.fontTextStyle = .smilesBody2
        
        primaryButton.setTitle("SubmitTitleSmall".localizedString, for: .normal)
        secondaryButton.setTitle("GetSupport".localizedString, for: .normal)
        primaryButton.fontTextStyle = .smilesHeadline4
        secondaryButton.fontTextStyle = .smilesHeadline4
        secondaryButton.layer.borderWidth = 2
        secondaryButton.layer.borderColor = UIColor.appRevampPurpleMainColor.withAlphaComponent(0.4).cgColor
        roundedView.layer.cornerRadius = 12
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public init(submitAction: @escaping ()->Void = {}, supportAction: @escaping ()->Void = {}) {
        self.submitAction = submitAction
        self.supportAction = supportAction
        super.init(nibName: "SmilesOrderCancelledViewController", bundle: .module)
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
        submitAction()
    }
    
    @IBAction func secondaryAction(_ sender: Any) {
        dismiss(animated: true)
        supportAction()
    }
    
}
