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
    let dispatchGroup = DispatchGroup()
    let friendsRef = Firestore.firestore().collection("friendList")
    let usersRef = Firestore.firestore().collection("users")
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let currentEmail = UsersData().getCurrentEmail()
    let currentUser = UsersData().getCurrentUser()
    
    
    func storeListsToUserDefaults(_ name: String){
    
        //let docRef = self.friendsRef.document(name)
        //docRef.getDocument { (document, error) in
            
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
                    
                        self.defaults.set(data[K.FStore.FriendList] as? [String], forKey: K.FStore.FriendList)
                        self.defaults.set(data[K.FStore.pendingLists] as? [String], forKey: K.FStore.pendingLists)
                        //self.storeFriendList()

                }
            }
        }
        
    }
    
    
    
    func storeFriendList(){
        
        var listArray = defaults.array(forKey: K.FStore.FriendList) as! [String]
        
        
        
//        for friends in friendlistArray{
//            context.delete(friends)
//                saveData()
//        }
        
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
        
        usersRef.document(email).getDocument { (userDoc, error) in
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
    //delete pendinglist
    func declineFriendship(_ email: String) {
        
        friendsRef.document(currentUser).updateData([K.FStore.pendingLists : FieldValue.arrayRemove([email])])
    }
    //delete both side of friendList
    func deleteFriend(Email email: String, Name name: String){
        friendsRef.document(currentUser).updateData([K.FStore.FriendList : FieldValue.arrayRemove([email])])
        friendsRef.document(name).updateData([K.FStore.FriendList : FieldValue.arrayRemove([currentEmail])])
        
    }

    
    func acceptFriend(Email email: String, Name name: String){
        friendsRef.document(currentUser).getDocument { (userDoc, error) in
            if let e = error{
                print("accept friends error on getting data \(e)")
            }
            else{
                if let userData = userDoc?.data(){
                    if userData[K.FStore.FriendList] == nil{
                        self.friendsRef.document(self.currentUser).setData([K.FStore.FriendList : FieldValue.arrayUnion([email])])
                        self.friendsRef.document(self.currentUser).updateData([K.FStore.pendingLists : FieldValue.arrayRemove([email])])
                        print("accept friend #1, added to users friendList")
                    }else{
                        self.friendsRef.document(self.currentUser).updateData([K.FStore.FriendList : FieldValue.arrayUnion([email])])
                        self.friendsRef.document(self.currentUser).updateData([K.FStore.pendingLists : FieldValue.arrayRemove([email])])
                        print("accept friend #1, added to users friendList")
                    }
                }
            }
        }
        
        friendsRef.document(name).getDocument { (targetDoc, error) in
            if let e = error{
                print("accept friends error on getting data \(e)")
            }
            else{
                if let targetData = targetDoc?.data(){
                    if targetData[K.FStore.FriendList] == nil{
                        self.friendsRef.document(name).setData([K.FStore.FriendList : FieldValue.arrayUnion([self.currentEmail])])
                        print("target* add friend #1, added to users friendList")
                    }else{
                        self.friendsRef.document(name).updateData([K.FStore.FriendList : FieldValue.arrayUnion([self.currentEmail])])
                        print("target* add friend #1, added to users friendList")
                    }
                }
            }
        }
    }
    
    
    
//    friendsRef.document(currentUser).updateData([K.FStore.FriendList : FieldValue.arrayRemove([email])])
//    friendsRef.document(name).updateData([K.FStore.FriendList : FieldValue.arrayRemove([currentEmail])])
    
    
    
    func addFriend(Email email: String) {
        
        
        friendsRef.document(currentUser).getDocument { (userDoc, error) in
            if let e = error{
                print("accept friends error on getting data \(e)")
            }
            else{
                if let userData = userDoc?.data(){
                        self.friendsRef.document(self.currentUser).updateData([K.FStore.FriendList : FieldValue.arrayUnion([email])])
                        print("accept friend #2, added to users friendList\(userData)")
                }else{
                    self.friendsRef.document(self.currentUser).setData([K.FStore.FriendList : FieldValue.arrayUnion([email])])
                    print("accept friend #1, added to users friendList")
                }
         
            }
    }
        
        
        usersRef.document(email).getDocument { (targetDoc, error) in
            if let e = error{
                print("accept friends error on getting data \(e)")
            }
            else{
                guard let document = targetDoc else {
                    print("error getting data")
                    return
                }
                guard let data = document.data() else{
                    print("no data")
                    return
                }
                guard let name = data["name"] as? String else {
                    print("no name")
                    return
                }
                print(name)
                self.friendsRef.document(name).getDocument { (doc, error) in
                    if let e = error{
                        print("accept friends error on getting data \(e)")
                    }
                    else{
                        guard let targetDocument = doc else{
                            print("error getting target data")
                            return
                        }
                        guard let data = targetDocument.data() else {
                            self.friendsRef.document(name).setData([K.FStore.FriendList : FieldValue.arrayUnion([self.currentEmail])])
                            return
                        }
                        self.friendsRef.document(name).updateData([K.FStore.FriendList : FieldValue.arrayUnion([self.currentEmail])])
                        print(" HI HERE")
                    }
            }
                
                
                
            
                    
            }
        }
        
        
        
    }
        
        
    
    
    
    
    
    
    
    
    func run(after seconds: Int, completion: @escaping () -> Void){
        let time  = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: time) {
            completion()
        }
        
        
    }
    
    
    
    
    
    
    
}
