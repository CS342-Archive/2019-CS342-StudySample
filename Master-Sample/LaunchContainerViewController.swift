//
//  ViewController.swift
//  Master-Sample
//
//  Created by Santiago Gutierrez on 9/22/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit
import ResearchKit

class LaunchContainerViewController: UIViewController {
    
    var contentHidden = false {
        didSet {
            guard contentHidden != oldValue && isViewLoaded else { return }
            children.first?.view.isHidden = contentHidden
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            toStudy()
        }
        else {
            toOnboarding()
        }
    }
    
    @IBAction func unwindToStudy(_ unwindSegue: UIStoryboardSegue) {
        toStudy()
    }
    
    // MARK: Transitions
    
    func toStudy() {
        performSegue(withIdentifier: "toStudy", sender: self)
    }
    
    func toOnboarding() {
        performSegue(withIdentifier: "toOnboarding", sender: self)
    }

}

