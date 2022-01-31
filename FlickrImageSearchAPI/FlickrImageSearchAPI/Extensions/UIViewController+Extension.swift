//
//  UIViewController+Extension.swift
//  FlickrImageSearchAPI
//
//  Created by Vinay B. Naikade on 31/01/22.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String = CommonStrings.error.rawValue, message: String, cancelButtonTitle: String = CommonStrings.cancel.rawValue, cancelButtonAction:(() -> Void)? = nil, otherButtonTitle: String = CommonStrings.okay.rawValue, otherButtonAction:(() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if !otherButtonTitle.isEmpty {
            let otherButtonAlertAction = UIAlertAction(title: otherButtonTitle, style: UIAlertAction.Style.default) { (alertAction) in
                if let action = otherButtonAction {
                    action()
                }
            }
            alertController.addAction(otherButtonAlertAction)
        }
        if !cancelButtonTitle.isEmpty {
            let cancelButtonAlertAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.default) { (alertAction) in
                if let action = cancelButtonAction {
                    action()
                }
            }
            alertController.addAction(cancelButtonAlertAction)
        }
        present(alertController, animated: false, completion: nil)
    }
    
}
