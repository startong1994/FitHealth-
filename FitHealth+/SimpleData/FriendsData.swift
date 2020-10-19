//
//  friendsData.swift
//  FitHealth+
//
//  Created by xu daitong on 10/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//
import Foundation


class FriendsData {
    
    
    var friendData = [
                Friends(name: "Daitong Xu", email: "dxu5@uncc.edu", profileImage: "person"),
                Friends(name: "Fayliette", email: "Flewis2@uncc.edu", profileImage: "person"),
                Friends(name: "Max Ries", email: "mries2@uncc.edu", profileImage: "person"),
                Friends(name: "Catherine Cheatle", email: "ccheatle@uncc.edu", profileImage: "person"),
                Friends(name: "J.R.", email: "@uncc.edu", profileImage: "person"),
                Friends(name: "Kendall Kling", email: "kkling@uncc.edu", profileImage: "person")
    ]
    
    var profileIndex: Int = 0
    
    
    
    func getName(_ row: Int) -> String {
        return friendData[row].name
    }
    func getEmail(_ row: Int) -> String {
        return friendData[row].email
    }
    func getProfileImage(_ row: Int) -> String {
        return friendData[row].profileImage
    }
    func addFriend(Name newName: String, Email newEmail: String){
        self.friendData.append(Friends(name: newName, email: newEmail, profileImage: newName))
    }
    func removeFriend(_ index: Int){
        self.friendData.remove(at: index)
    }
    func setProfileIndex(_ index: Int) {
        profileIndex = index
    }
    func getProfileIndex() -> Int {
        return profileIndex
    }
    
    
    
}
