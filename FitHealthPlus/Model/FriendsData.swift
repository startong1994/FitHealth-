//
//  FriendsData.swift
//  FitHealthPlus
//
//  Created by xu daitong on 11/12/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CoreData

class FriendsData {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var friendlistArray = [FriendLists]()
    var pendingListArray = [PendingLists]()
    
    func saveData(){
        do{
            try self.context.save()
        }catch{
            print("error saving context \(error)")
        }
    }
    func loadFriendList() -> [FriendLists]{
        pendingListArray = []
        let request : NSFetchRequest<FriendLists> = FriendLists.fetchRequest()
        do{
            self.friendlistArray = try context.fetch(request)
        } catch{
            print("error on loading friendList\(error)")
        }
        
        return friendlistArray
    }
    func loadPendingFriends() -> [PendingLists] {
        pendingListArray = []
        let request : NSFetchRequest<PendingLists> = PendingLists.fetchRequest()
        do{
            self.pendingListArray = try context.fetch(request)
        } catch{
            print("error on loading friendList\(error)")
        }
        
        return pendingListArray
    }
    func removeAllData(){
        
        friendlistArray = loadFriendList()
        pendingListArray = loadPendingFriends()
        
        for friends in friendlistArray{
            context.delete(friends)
                saveData()
        }
        for pendingFriends in pendingListArray{
            context.delete(pendingFriends)
                saveData()
        }
        
    }
    
}
