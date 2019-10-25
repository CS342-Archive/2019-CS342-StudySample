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
    
    static let db = Firestore.firestore()
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    class func login(_ eid: String, completion: @escaping (Bool)->Void) {
        guard !eid.isEmpty else {
            completion(false)
            return
        }
        
        /*let actionCodeSettings = ActionCodeSettings()
        //actionCodeSettings.url = URL(string: "https://www.example.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        Auth.auth().sendSignInLink(toEmail: "ssgutierrez42@gmail.com", actionCodeSettings: actionCodeSettings) { (error) in
            guard let _ = authResult?.user else {
                completion(false)
                return
            }
            
            completion(true)
        }*/
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else {
                completion(false)
                return
            }
            
            userExists(eid, completion: { (document, exists) in
                if let document = document {
                    db.collection("users").document(document.documentID).setData(["userID":user.uid, "lastActive":Date().ISOStringFromDate()])
                } else if !exists {
                    db.collection("users").addDocument(data: ["eID": eid, "userID": user.uid, "lastActive":Date().ISOStringFromDate()])
                }
                
                completion(true)
            })
        }
    }
    
    class func userExists(_ eid: String, completion: @escaping (QueryDocumentSnapshot?, Bool)->Void) {
        
        db.collection("study_users").whereField("eid", isEqualTo: eid).getDocuments() { (snapshot, err) in
            guard let snapshot = snapshot else {
                print(err?.localizedDescription)
                completion(nil, false)
                return
            }
            
            assert(snapshot.documents.count <= 1)
            completion(snapshot.documents.first, snapshot.documents.count == 1)
        }
        
    }
    
}
