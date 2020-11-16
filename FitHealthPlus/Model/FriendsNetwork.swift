//
//  FriendsNetwork.swift
//  FitHealthPlus
//
//  Created by xu daitong on 11/16/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CoreData

class FriendNetwork {
    let friendsRef = Firestore.firestore().collection("friendList")
    let usersRef = Firestore.firestore().collection("users")
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func storeListsToUserDefaults(_ name: String){
    
        //let docRef = self.friendsRef.document(name)
        //docRef.getDocument { (document, error) in
        FriendsData().removeAllData()
            
            
        friendsRef.document(name).addSnapshotListener{ (document, error) in
            
            print("data changed")
            if let e = error{
                print("error \(e)")
            }
            else{
                if let document = document, document.exists{
                    if let friendListEmails = document.data()![K.FStore.FriendList]! as? [String]{
                        self.defaults.set(friendListEmails, forKey: K.FStore.FriendList)
                        self.storeFriendList()
                        print("count")
                        
                    }
                    if let pendingListEmails = document.data()![K.FStore.pendingLists]! as? [String]{
                        self.defaults.set(pendingListEmails, forKey: K.FStore.pendingLists)
                        self.storePendingLists()
                        print("count count")
                    }
                }
            }
        }
            
    }
    
    
    func storeFriendList(){
        
        let listArray = defaults.array(forKey: K.FStore.FriendList) as! [String]
        
        for email in listArray{
            
            let request: NSFetchRequest<FriendLists> = FriendLists.fetchRequest()
            
            let predicate = NSPredicate(format: "email CONTAINS[cd] %@", email)
            
            request.predicate = predicate
            
            let userRef = self.usersRef.document(email)
            userRef.getDocument { (document, error) in
                if let e = error{
                    print(e)
                }
                else{
                    
                    if let document = document, document.exists{
                        let data = document.data()
                        if let friendName = data!["name"] as? String, let friendEmail = data!["email"] as? String,
                           let friendProfileImage = data!["profileImage"] as? String{
                            let newFriends = FriendLists(context: self.context)
                            newFriends.email = friendEmail
                            newFriends.name = friendName
                            newFriends.profileImage = friendProfileImage
                            FriendsData().saveData()
                        }
                    }
                }
            }
        }
        }
    func storePendingLists(){
        let listArray = defaults.array(forKey: K.FStore.pendingLists) as! [String]
        
        for email in listArray{
            
            let request: NSFetchRequest<PendingLists> = PendingLists.fetchRequest()
            
            let predicate = NSPredicate(format: "email CONTAINS[cd] %@", email)
            
            request.predicate = predicate
            
            
            let userRef = self.usersRef.document(email)
            userRef.getDocument { (document, error) in
                if let e = error{
                    print(e)
                }
                else{
                    
                    if let document = document, document.exists{
                        let data = document.data()
                        if let friendName = data!["name"] as? String, let friendEmail = data!["email"] as? String,
                           let friendProfileImage = data!["profileImage"] as? String{
                            let newFriends = PendingLists(context: self.context)
                            newFriends.email = friendEmail
                            newFriends.name = friendName
                            newFriends.profileImage = friendProfileImage
                            FriendsData().saveData()
                        }
                    }
                }
            }
        }
    
        }
    
    
    
    
}
