//
//  StudyContainerTabBarController.swift
//  Master-Sample
//
//  Created by Santiago Gutierrez on 9/22/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class StudyContainerTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = CareKitManager.shared.storeManager
        let careViewController = CareViewController(storeManager: manager)
        careViewController.tabBarItem = UITabBarItem(title: "CareKit", image: UIImage(named: "tab_activities"), tag: 0)
        let navParent = UINavigationController(rootViewController: careViewController)
        
        var updatedViewControllers = self.viewControllers
        updatedViewControllers?.insert(navParent, at: 0)
        self.setViewControllers(updatedViewControllers, animated: false)
    }
    
}
