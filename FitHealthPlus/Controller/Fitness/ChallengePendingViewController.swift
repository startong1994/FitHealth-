//
//  ChallengePendingViewController.swift
//  FitHealthPlus
//
//  Created by xu daitong on 12/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ChallengePendingViewController: UIViewController {
    
    let challengePendingRef = Firestore.firestore().collection("challengePendingList")
    let challengeRef = Firestore.firestore().collection("challenge")
    let challengeListRef = Firestore.firestore().collection("challengeList")
    
    
    @IBOutlet weak var tableView: UITableView!
    var challengePending: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "pending challenges"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        reload()
    }
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        print("acceptButton pressed")
    }
    @IBAction func declineButtonPressed(_ sender: UIButton) {
        print("declineButton pressed")
    }
}
    
    
    
extension ChallengePendingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengePending.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengePendingCell", for: indexPath)
        cell.textLabel?.text = challengePending[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let alert = UIAlertController(title: " Challenge it! ", message: " ", preferredStyle: .alert)
        let accpet = UIAlertAction(title: "accpet", style: .default) { (accept) in
            self.challengePendingRef.document(UsersData().getCurrentUser()).updateData(["pending" : FieldValue.arrayRemove([self.challengePending[indexPath.row]])])
            
            
            self.challengeRef.document(self.challengePending[indexPath.row]).getDocument { (doc, error) in
                if let error = error{
                    print("error getting doc \(error)")
                }else{
                    guard let data = doc?.data() else {
                        print("no such challenges")
                        return
                    }
                        self.challengeRef.document(self.challengePending[indexPath.row]).updateData([K.FStore.challengeFriends : FieldValue.arrayUnion([UsersData().getCurrentUser()])])
                }
                
            }
            
            ChallengeNetwork().addChallenge(self.challengePending[indexPath.row])
            
            FriendNetwork().run(after: 1) {
                self.reload()
            }
            
        }
        
        let decline = UIAlertAction(title: "decline", style: .default) { (decline) in
            self.challengePendingRef.document(UsersData().getCurrentUser()).updateData(["pending" : FieldValue.arrayRemove([self.challengePending[indexPath.row]])])
            FriendNetwork().run(after: 1) {
                self.reload()
            }
            
        }
        alert.addAction(accpet)
        alert.addAction(decline)
        
        present(alert, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func reload(){
        
        challengePendingRef.document(UsersData().getCurrentUser()).getDocument { (doc, error) in
            if let error = error{
                print("error getting doc\(error)")
            }else{
                guard let data = doc?.data() else {
                    print("error getting data")
                    return
                }
                if let pendingList = data["pending"] as? [String]{
                    self.challengePending = pendingList
                    print(pendingList)
                    print("Hi")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
        }
        
    }
    
    
    
    
    
    
    }

