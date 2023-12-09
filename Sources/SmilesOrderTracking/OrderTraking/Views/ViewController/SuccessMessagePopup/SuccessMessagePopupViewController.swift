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
      
        
        roundedView.layer.cornerRadius = 12
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalPresentationStyle = .overFullScreen
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        primaryButton.fontTextStyle = .smilesHeadline4
        primaryButton.titleLabel?.textColor = .white
        primaryButton.backgroundColor = .appRevampPurpleMainColor
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
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss{
            self.data.primaryAction()
        }
    }
    
    @IBAction func primaryAction(_ sender: Any) {
        dismiss{
            self.data.primaryAction()
        }
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
