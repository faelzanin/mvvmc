//
//  UIView+Utils.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import UIKit

extension UIView  {
    
    /// Show loading in view
    func showHUD() {
        PKHUD.sharedHUD.dimsBackground = true
        let activity = NVActivityIndicatorView(frame: CGRect(x: 1, y: 1, width: 50, height: 50),
                                               type: .ballClipRotateWithoutScale,
                                               color: UIColor.cyan,
                                               padding: 0.0 )
        activity.startAnimating()
        activity.clipsToBounds = false
        PKHUD.sharedHUD.contentView = activity
        DispatchQueue.main.async {
            PKHUD.sharedHUD.show()
        }
    }
    
    /// Hide loading in view
    func hideHUD() {
        DispatchQueue.main.async {
            PKHUD.sharedHUD.hide()
        }
    }
}
