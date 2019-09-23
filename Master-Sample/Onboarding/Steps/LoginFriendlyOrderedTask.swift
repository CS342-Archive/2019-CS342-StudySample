//
//  LoginFriendlyOrderedTask.swift
//  Master-Sample
//
//  Created by Santiago Gutierrez on 9/22/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

/*import ResearchKit
import CS342Support

class LoginFriendlyOrderedTask : ORKOrderedTask {
    
    override func step(after step: ORKStep?, with result: ORKTaskResult) -> ORKStep? {
        
        switch step?.identifier {
        case .some(LoginStep.identifier):
            
            let stepResult = result.stepResult(forStepIdentifier: LoginStep.identifier)
            if let idRes = stepResult?.results?.first as? ORKTextQuestionResult, let id = idRes.textAnswer,
                let idConfirmRes = stepResult?.results?.last as? ORKTextQuestionResult, let idConfirm = idConfirmRes.textAnswer {
                
                if id == idConfirm {
                    return LoginWaitStep(identifier: LoginWaitStep.identifier, id: idConfirm)
                } else {
                    Alerts.showInfo(title: "Unable to Verify", message: "The two IDs that you entered don't match.")
                }
            }
            
            return LoginStep(identifier: LoginWaitStep.identifier)
        case .some(LoginWaitStep.identifier):
            
            
            return LoginStep(identifier: LoginWaitStep.identifier) //or continue
        default:
            return super.step(after: step, with: result)
        }
    }
    
    override func step(before step: ORKStep?, with result: ORKTaskResult) -> ORKStep? {
        return super.step(before: step, with: result)
    }
    
}*/
