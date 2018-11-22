//
//  NavigationViewController.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController, UINavigationBarDelegate {
    
    var statusBarStyle: UIStatusBarStyle = .default
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultNavigationStyle()
        self.tabBarItem.title                   = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
     // MARK: Methods
    func defaultNavigationStyle() {
        navigationBar.barTintColor              = .white
        navigationBar.tintColor                 = .white
        navigationBar.titleTextAttributes       = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.isTranslucent             = false
        navigationBar.shadowImage               = UIImage()
    }
    func defaultTransparentStyle() {
        navigationBar.isHidden                  = true
    }
}
