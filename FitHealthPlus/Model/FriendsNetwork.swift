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
    let currentEmail = UsersData().getCurrentEmail()
    let currentUser = UsersData().getCurrentUser()
    
    
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
                if let document = document{
                    
                    guard let data = document.data() else {
                        print("error getting data")
                        return
                    }
                    if let friendEmails = data[K.FStore.FriendList] as? [String]{
                        self.defaults.set(friendEmails, forKey: K.FStore.FriendList)
                        self.storeFriendList()
                    }
                    if let pendingEmaisl = data[K.FStore.pendingLists] as? [String]{
                        self.defaults.set(pendingEmaisl, forKey: K.FStore.pendingLists)
                        self.storePendingLists()
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
    func friendRequest(_ email: String) {
        let userRef = usersRef.document(email)
        userRef.getDocument { (userDoc, error) in
            if let e = error{
                print("error on getting user documents \(e)")
            }
            else{
                if let userDoc = userDoc{
                    
                    //first check if target is exsit and then get the targetName
                    if userDoc.data() != nil{
                        let targetName = userDoc.data()![K.FStore.name] as! String
                
                        self.friendsRef.document(targetName).getDocument { (friendDoc, Error) in
                            if let e = error{
                                print("error on getting friend documents \(e)")
                            }
                            else{
                                // check if pendingList is empty,
                                //if friendDoc?.data() != nil{
                                guard let data = friendDoc?.data() else{
                                    self.friendsRef.document(targetName).setData([K.FStore.pendingLists : FieldValue.arrayUnion([self.currentEmail])])
                                    print("no name, new name added")
                                    return
                                }
                                if data[K.FStore.pendingLists] == nil{
                                    self.friendsRef.document(targetName).setData([K.FStore.pendingLists : FieldValue.arrayUnion([self.currentEmail])])
                                    print("set data succ")
                                }
                                else{
                                    self.friendsRef.document(targetName).updateData([K.FStore.pendingLists : FieldValue.arrayUnion([self.currentEmail])])
                                    print("updated")
                                }
                                    }
                                //}
                            }
                        }
                        
                        
                    }
                }
            }
        }
    func declineFriendship(_ email: String) {
        let friendRef = friendsRef.document(currentUser)
        friendRef.updateData([K.FStore.pendingLists : FieldValue.arrayRemove([email])])
    }
    
    
    
    
    
    
    
    
    }

    
//    func addFriend(_ email: String){
//        friendsRef.document("Dationg Xu").updateData(["PendingFriends" : FieldValue.arrayUnion([email])])
//    }
//
//
//
//
//}
