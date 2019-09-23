//
//  LoginStep.swift
//  Master-Sample
//
//  Created by Santiago Gutierrez on 9/22/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import ResearchKit

class LoginStep: ORKFormStep {
    
    static let identifier = "Login"
    
    static let idStepIdentifier = "IdStep"
    static let idConfirmStepIdentifier = "ConfirmIdStep"
    
    override init(identifier: String) {
        super.init(identifier: identifier)
        
        title = NSLocalizedString("Login", comment: "")
        text = NSLocalizedString("Please enter the participant ID that you received in-clinic 👨🏽‍⚕️", comment: "")
        
        formItems = createFormItems()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createFormItems() -> [ORKFormItem] {
        let idAnswerFormat = ORKTextAnswerFormat(maximumLength: 25)
        idAnswerFormat.multipleLines = false
        let idStepTitle = "Enter ID:"
        let idQuestionStep = ORKFormItem(identifier: LoginStep.idStepIdentifier, text: idStepTitle, answerFormat: idAnswerFormat, optional: false)
        
        let idConfirmAnswerFormat = ORKTextAnswerFormat(maximumLength: 25)
        idConfirmAnswerFormat.multipleLines = false
        let idConfirmStepTitle = "Confirm ID:"
        let idConfirmQuestionStep = ORKFormItem(identifier: LoginStep.idConfirmStepIdentifier, text: idConfirmStepTitle, answerFormat: idConfirmAnswerFormat, optional: false)
        
        return [idQuestionStep, idConfirmQuestionStep]
    }
    
}
