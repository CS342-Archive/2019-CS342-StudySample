//
//  LoginWaitStep.swift
//  Master-Sample
//
//  Created by Santiago Gutierrez on 9/22/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import ResearchKit

class LoginWaitStep: ORKWaitStep {
    
    static let identifier = "LoginWait"
    
    var loginId: String = ""
    
    override init(identifier: String) {
        super.init(identifier: identifier)
        
        title = NSLocalizedString("Getting Ready... 📝", comment: "")
        text = NSLocalizedString("Please wait while we validate your credentials", comment: "")
    }
    
    convenience init(identifier: String, id: String) {
        self.init(identifier: identifier)
        self.loginId = id
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
