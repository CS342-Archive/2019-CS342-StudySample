//
//  StudyUser.swift
//  Master-Sample
//
//  Created by Santiago Gutierrez on 9/22/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class StudyUser {
    
    static let shared = StudyUser()
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    class func login(completion: @escaping (Bool)->Void) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let _ = authResult?.user else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
}
