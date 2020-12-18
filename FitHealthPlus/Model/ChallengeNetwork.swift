//
//  ChallengeNetwork.swift
//  FitHealthPlus
//
//  Created by xu daitong on 12/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ChallengeNetwork{
    let pendingListRef = Firestore.firestore().collection("challengePendingList")
    let challengeListRef = Firestore.firestore().collection("challengeList")
    let challengeProgressRef = Firestore.firestore().collection("challengeProgress")
    
    func addChallenge(_ challengeName: String) {
        challengeListRef.document(UsersData().getCurrentUser()).getDocument { (document, error) in
            if let error = error{
                print("error getting challengeList \(error)")
            }else{
                guard let doc = document else {
                    print("error getting doc")
                    return
                }
                self.initChallengeProgress(challengeName)
                guard let data = doc.data() else{
                    self.challengeListRef.document(UsersData().getCurrentUser()).setData([K.FStore.challengeName : FieldValue.arrayUnion([challengeName])])
                    print("created and set challengeName")
                    return
                }
                self.challengeListRef.document(UsersData().getCurrentUser()).updateData([K.FStore.challengeName : FieldValue.arrayUnion([challengeName])])
                    print("added challengeName")
        }
    }
    }
    func initChallengeProgress(_ challengeName: String) {
        
        challengeProgressRef.document(UsersData().getCurrentUser()).getDocument { (doc, error) in
            if let error = error{
                print(error)
            }else{
                guard let data = doc?.data() else {
                    print("no document")
                    self.challengeProgressRef.document(UsersData().getCurrentUser()).setData([challengeName : FieldValue.arrayUnion([0])])
                    return
                }
                self.challengeProgressRef.document(UsersData().getCurrentUser()).updateData([challengeName : FieldValue.arrayUnion([0])])
//                if data.count == 1{
//                    challengeProgressRef.document(UsersData().getCurrentUser()).setData([challengeName : FieldValue.arrayUnion([0])])
//                }

            }
        }
    }
    
    
    
    
    func challengeRequestSent(_ friends: [String], _ challengeName: String){
        
        for friend in friends{
            
            pendingListRef.document(friend).getDocument { (doc, error) in
                if let error = error{
                    print("error getting doc\(error)")
                }else{
                    guard let data = doc?.data() else {
                        self.pendingListRef.document(friend).setData(["pending": FieldValue.arrayUnion([challengeName])])
                        return
                    }
                    self.pendingListRef.document(friend).updateData(["pending": FieldValue.arrayUnion([challengeName])])

                }
            }
        }
        
        
    }
    
    func updatingProgress(NewProgress newProgress: Int,ChallengeName  challengeName: String){
        challengeProgressRef.document(UsersData().getCurrentUser()).updateData([challengeName : FieldValue.arrayUnion([newProgress])])
    }
    
    
    
}
