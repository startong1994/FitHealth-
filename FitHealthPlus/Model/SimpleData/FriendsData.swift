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
                Friends(name: "Fayliette", email: "Flewis2@uncc.edu", profileImage: "person", step: 4000),
                Friends(name: "Max Ries", email: "mries2@uncc.edu", profileImage: "person", step: 3000),
                Friends(name: "Catherine Cheatle", email: "ccheatle@uncc.edu", profileImage: "person", step: 2000),
                Friends(name: "J.R.", email: "@uncc.edu", profileImage: "person", step: 1000),
                Friends(name: "Kendall Kling", email: "kkling@uncc.edu", profileImage: "person", step: 500)
    ]
    
    
    var newFriendData = [
        Friends(name: "Daitong Xu", email: "dxu5@uncc.edu", profileImage: "person", step: 100)
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
    func addFriend(Name newName: String, Email newEmail: String, Step newStep: Int){
        self.friendData.append(Friends(name: newName, email: newEmail, profileImage: newName, step: newStep))
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
    
    func getSteps(_ row: Int) -> Int{
        return friendData[row].step
    }
    
    
    
    //new friends section
    
    func getNewFriendProfileImage(_ row: Int) -> String {
        return newFriendData[row].profileImage
    }
    func getNewFriendName(_ row: Int) -> String {
        return newFriendData[row].name
    }
    func getNewFriendEmail(_ row: Int) -> String {
        return newFriendData[row].email
    }
    
    
    
    
}
