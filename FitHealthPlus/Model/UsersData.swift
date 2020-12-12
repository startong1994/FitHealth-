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
    let friendsRef = Firestore.firestore().collection("friendList")
    
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
    
    func changeCurrentUserName(_ name: String){
        self.userRef.document(getCurrentEmail()).updateData(["name" : name])
    }
    func changeCurrentUserProfilePic(_ image: String){
        self.userRef.document(getCurrentEmail()).updateData(["name" : image])
    }
    func changeCurrentUserPassword(_ password: String){
        Auth.auth().currentUser?.updatePassword(to: password, completion: nil)
    }
    func deleteAccount(){
        
        //delete friends fr
        friendsRef.document(getCurrentUser()).getDocument { (doc, error) in
            guard let docRef = doc else{
                print("error getting data")
                return
            }
            guard let data = docRef.data() else{
                print("error getting FriendsList")
                return
            }
            print("deleteAccount Function check 1")
            if let friendList = data[K.FStore.FriendList] as? [String]{
                for friendEmail in friendList{
                    userRef.document(friendEmail).getDocument { (doc, error) in
                        guard let doc = doc else{
                            print("error getting data")
                            return
                        }
                        guard let data = doc.data() else{
                            print("error getting user's profile data")
                            return
                        }
                        guard let friendName = data[K.FStore.name] as? String else{
                            print("error getting user's name")
                            return
                        }
                        FriendNetwork().deleteFriend(friendEmail: friendEmail, friendName: friendName)
                        print("delete friend name \(friendName)")
                        print("delete friend email \(friendEmail)")
                    }
                }
            }
        }
        
        //delete user's doc
        userRef.document(getCurrentEmail()).delete(){ err in
            if let err = err{
                print("error removing users data\(err)")
            }else{
                print("successfully")
            }
        }
        //delete friend's list doc
        friendsRef.document(getCurrentUser()).delete(){ err in
            if let err = err{
                print("error removing friendsList data \(err)")
            }else{
                print("successfully")
            }
        }
        /**
         codes for other section, to delete users data
         */
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //* delete account
        Auth.auth().currentUser?.delete(completion: { (error) in
            if let e = error{
                print("error delete data \(e)")
            }else{
                print("successed")
            }
        })
    }
    
    /**
     
     other users data
     
     */
    
    
    
    
    
    
    
}
