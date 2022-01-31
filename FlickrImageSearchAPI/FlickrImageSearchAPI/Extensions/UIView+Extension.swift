//
//  UIView+Extension.swift
//  FlickrImageSearchAPI
//
//  Created by Vinay B. Naikade on 31/01/22.
//

import UIKit

extension UIView {
    
    func viewFromNib(nib: AnyClass, owner: Any?) -> UIView {
        let xib = UINib(nibName: String(describing: nib).components(separatedBy: ".").last!, bundle: Bundle.main)
        let view = xib.instantiate(withOwner: owner, options: nil).first as! UIView
        return view
    }
    
}
