//
//  File.swift
//
//
//  Created by Ahmed Naguib on 04/12/2023.
//

import UIKit
import SmilesUtilities

extension UIViewController {
    func makePhoneCall(phoneNumber: String) {
        if let _ = NSURL(string: "tel://" + phoneNumber) {
            let alert = UIAlertController(title: "\("CallBtnTitle".localizedString) " + phoneNumber + "?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CallBtnTitle".localizedString, style: .default, handler: { _ in
                OperatorUtility().callNumber(number: phoneNumber)
            }))
            
            alert.addAction(UIAlertAction(title: "CANCEL".localizedString, style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
