//
//  File.swift
//  
//
//  Created by Shmeel Ahmed on 20/11/2023.
//

import Foundation
struct ConfirmationPopupViewModelData {
    var showCloseButton = true
    var popupTitle:String?
    var message:String
    var descriptionMessage:String?
    var primaryButtonTitle:String
    var secondaryButtonTitle:String
    var primaryAction={}
    var secondaryAction={}
}
