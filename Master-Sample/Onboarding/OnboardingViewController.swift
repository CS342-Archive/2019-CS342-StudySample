//
//  OnboardingViewController.swift
//  Master-Sample
//
//  Created by Santiago Gutierrez on 9/22/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit
import ResearchKit
import CS342Support

class OnboardingViewController: UIViewController {
    
    // MARK: IB actions
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        
        let consentDocument = ConsentDocument()
        let consentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
        
        let healthDataStep = HealthDataStep(identifier: "Health")
        
        let signature = consentDocument.signatures!.first!
        
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
        reviewConsentStep.text = "Review the consent form."
        reviewConsentStep.reasonForConsent = "Consent to join the Developer Health Research Study."
        
        let loginStep = LoginStep(identifier: LoginStep.identifier)
        let loginVerificationStep = LoginWaitStep(identifier: LoginWaitStep.identifier)
        
        //NOTE: requires NSFaceIDUsageDescription in info.plist
        let passcodeStep = ORKPasscodeStep(identifier: "Passcode")
        passcodeStep.text = "Now you will create a passcode to identify yourself to the app and protect access to information you've entered."
        
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = "Welcome aboard."
        completionStep.text = "Thank you for joining this study."
        
        let orderedTask = ORKOrderedTask(identifier: "Join", steps: [consentStep, reviewConsentStep, healthDataStep, loginStep, loginVerificationStep, passcodeStep, completionStep])
        let taskViewController = ORKTaskViewController(task: orderedTask, taskRun: nil)
        taskViewController.delegate = self
        
        present(taskViewController, animated: true, completion: nil)
    }
    
}

extension OnboardingViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        
        if stepViewController.step?.identifier == LoginStep.identifier {
            
            /*if StudyUser.shared.currentUser != nil { //already logged in, skip
                stepViewController.goForward()
                return
            }*/
            
        } else if stepViewController.step?.identifier == LoginWaitStep.identifier {
            
            /*if StudyUser.shared.currentUser != nil { //already logged in, skip
                stepViewController.goForward()
                return
            }*/
            
            let stepResult = taskViewController.result.stepResult(forStepIdentifier: LoginStep.identifier)
            if let idRes = stepResult?.results?.first as? ORKTextQuestionResult, let id = idRes.textAnswer,
                let idConfirmRes = stepResult?.results?.last as? ORKTextQuestionResult, let idConfirm = idConfirmRes.textAnswer {
                
                if id == idConfirm {
                    StudyUser.login(id) { (success) in
                        guard success else {
                            DispatchQueue.main.async {
                                Alerts.showInfo(title: "Unable to Login", message: "Please try again in five minutes.")
                            }
                            return
                        }
                        stepViewController.goForward()
                    }
                } else {
                    stepViewController.goBackward()
                    DispatchQueue.main.async {
                        Alerts.showInfo(title: "Unable to Verify", message: "The two IDs that you entered don't match.")
                    }
                }
            }
            
        }
        
    }
    
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .completed:
            performSegue(withIdentifier: "unwindToStudy", sender: nil)
        case .discarded, .failed, .saved:
            fallthrough
        default:
            dismiss(animated: true, completion: nil)
        }
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
        if step is HealthDataStep {
            let healthStepViewController = HealthDataStepViewController(step: step)
            return healthStepViewController
        }
        
        return nil
    }
    
}
