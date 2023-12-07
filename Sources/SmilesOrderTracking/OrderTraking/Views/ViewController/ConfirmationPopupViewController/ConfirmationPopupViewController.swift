//
//  ConfirmationPopupViewController.swift
//  
//
//  Created by Shmeel Ahmed on 20/11/2023.
//

import UIKit
import SmilesUtilities
import SmilesLoader

public class ConfirmationPopupViewController: UIViewController {

    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var popupTitleContainer: UIView!
    
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet var panDismissView: UIView!

    @IBOutlet weak var messageText: UILabel!
    
    @IBOutlet weak var descriptionMessage: UILabel!
    
    var dismissViewTranslation = CGPoint(x: 0, y: 0)
    
    var data = ConfirmationPopupViewModelData(message: "", primaryButtonTitle: "", secondaryButtonTitle: "")
    // MARK: Lifecycle

    fileprivate func setupUI() {
        popupTitle.text = data.popupTitle
        messageText.text = data.message
        descriptionMessage.text = data.descriptionMessage
        descriptionMessage.isHidden = data.descriptionMessage?.isEmpty ?? true
        closeButton.isHidden = !data.showCloseButton
        popupTitleContainer.isHidden = !data.showCloseButton && (data.popupTitle?.isEmpty ?? true)
        popupTitle.fontTextStyle = .smilesHeadline4
        messageText.fontTextStyle = .smilesHeadline2
        descriptionMessage.fontTextStyle = .smilesBody2
        
        primaryButton.setTitle(data.primaryButtonTitle, for: .normal)
        secondaryButton.setTitle(data.secondaryButtonTitle, for: .normal)
       
        secondaryButton.layer.borderWidth = 2
        secondaryButton.layer.borderColor = UIColor.appRevampPurpleMainColor.withAlphaComponent(0.4).cgColor
        roundedView.layer.cornerRadius = 12
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        primaryButton.fontTextStyle = .smilesHeadline4
        secondaryButton.fontTextStyle = .smilesHeadline4
        
        primaryButton.titleLabel?.textColor = .white
        primaryButton.backgroundColor = .appRevampPurpleMainColor
        secondaryButton.titleLabel?.textColor = .appRevampPurpleMainColor
    }
    public init(popupData: ConfirmationPopupViewModelData) {
        self.data = popupData
        super.init(nibName: "ConfirmationPopupViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func primaryAction(_ sender: Any) {
        dismiss{
            self.data.primaryAction()
            
        }
    }
    
    @IBAction func secondaryAction(_ sender: Any) {
        dismiss{
            self.data.secondaryAction()
        }
    }
}
