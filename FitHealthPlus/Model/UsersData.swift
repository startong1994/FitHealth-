//
//  UsersData.swift
//  FitHealthPlus
//
//  Created by xu daitong on 11/12/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation
import Firebase


struct UsersData {
    
    /**
     

     get current user 's data,
     
     */
    
    
    let defaults = UserDefaults.standard
    let userRef = Firestore.firestore().collection("users")
    
    func getCurrentUser() -> String{
        if let name = defaults.dictionary(forKey: "CurrentUser")!["name"]{
            return name as! String
        }
        else{
            return "NO NAME"
        }
    }
    func getCurrentProfileImage() -> String{
        if let profileImage = defaults.dictionary(forKey: "CurrentUser")!["profileImage"]{
            return profileImage as! String
        }
        else{
            return "NO profileImage"
        }
    }
    
    func getCurrentEmail() -> String {
        if let email = defaults.dictionary(forKey: "CurrentUser")!["email"]{
            return email as! String
        }
        else{
            return "NO email"
        }
    }
    func storeCurrentUserData(){
        if let currentEmail = Auth.auth().currentUser?.email!{
            let docRef = self.userRef.document(currentEmail)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists{
                        let data = document.data()
                        self.defaults.set(data, forKey: "CurrentUser")
                        print("currentUser's data stored")
                    }
                }
        }
    }
    
    
    /**
     
        add new user to database
     
     */
    
    
    func addNewUser(email newEmail: String, name newName: String, profileImage newProfileImage: String)  {
        self.userRef.document(newEmail).setData([
                                                    "name": newName,
                                                    "email": newEmail,
                                                    "profileImage": newProfileImage])
    }
    
    
    
    
    /**
     
     other users data
     
     */
    
    
    
    
    
    
    
}
