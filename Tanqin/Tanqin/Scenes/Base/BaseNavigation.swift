//
//  BaseNavigation.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 23/10/2023.
//

import UIKit

class BaseNavigation: UINavigationController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
