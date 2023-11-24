//
//  File.swift
//  
//
//  Created by Shmeel Ahmed on 20/11/2023.
//

import Foundation
public struct ConfirmationPopupViewModelData {
    var showCloseButton = true
    var popupTitle:String?
    var message:String
    var descriptionMessage:String?
    var primaryButtonTitle:String
    var secondaryButtonTitle:String
    var primaryAction={}
    var secondaryAction={}
    public init(showCloseButton: Bool = true, popupTitle: String? = nil, message: String, descriptionMessage: String? = nil, primaryButtonTitle: String, secondaryButtonTitle: String, primaryAction: @escaping ()->Void = {}, secondaryAction: @escaping ()->Void = {}) {
        self.showCloseButton = showCloseButton
        self.popupTitle = popupTitle
        self.message = message
        self.descriptionMessage = descriptionMessage
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
}
