//
//  AddFriendViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CoreData

class AddFriendController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let db = Firestore.firestore()
    var pendingFriendList = [Friend]()
    var usersRef = Firestore.firestore().collection("users")
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Add Friends"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //loadPendingFriends()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        reload()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Friend", message: "", preferredStyle: .alert)
        let added = UIAlertController(title: "", message: "Request sent!", preferredStyle: .alert)
        
        var emailAddress = UITextField()
        
        
        //ok botton for conformation alert pop up
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        
        
        //confirm button function
        let addFriend = UIAlertAction(title: "Confirm", style: .default) { (addFriend) in
            if let address = emailAddress.text {
                if address.hasSuffix("uncc.edu"){
                print(address + " added")
                
                    
                
                    
                //add friends
                    
                    FriendNetwork().friendRequest(address)
                
                added.addAction(ok)
                self.present(added, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Error", message: "Please Enter UNCC School Email", preferredStyle: .alert)
                    
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        alert.addAction(addFriend)
        //cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Email Address"
            emailAddress = textField
        }
        alert.addAction(cancel)
        
        alert.preferredAction = addFriend
        present(alert,animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let profileImage = friendData.getNewFriendName(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "newFriendCell", for: indexPath)
        if pendingFriendList.count > 0{
            print(pendingFriendList[indexPath.row].name)
            cell.textLabel?.text = pendingFriendList[indexPath.row].name
            cell.imageView?.image = UIImage(named: pendingFriendList[indexPath.row].profileImage)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let pendingProfileVC = storyBoard.instantiateViewController(withIdentifier: "NewFriendProfile") as! NewFriendProfileViewController
        
        pendingProfileVC.pendingFriend = pendingFriendList[indexPath.row]
        print(pendingFriendList[indexPath.row])
        
        self.navigationController?.pushViewController(pendingProfileVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func reload(){
        if let friendsEmail = UserDefaults.standard.array(forKey: K.FStore.pendingLists) as? [String]{
            
 //           self.friendsRef.document(currentUser).addSnapshotListener { (doc, error) in
//                if let e = error{
//                    print(e)
//                } else{
                self.pendingFriendList = []
                    
                if friendsEmail.isEmpty{
                    tableView.reloadData()
                    }
                    print("test1  \(friendsEmail)")
                    
                    for emails in friendsEmail{
                        
                        self.usersRef.document(emails).getDocument { (doc, error) in
                            print("test2")
                            if let e = error{
                                print(e)
                                }else{
                                    guard let document = doc else {
                                    return
                                }
                                    guard let data = document.data() else {
                                    return
                                }
                                if let friendName = data["name"] as? String, let friendEmail = data["email"] as? String, let friendImge = data["profileImage"] as? String{
                                    print("test3")
                                    let list = Friend(name: friendName, email: friendEmail, profileImage: friendImge)
                                    self.pendingFriendList.append(list)
                                }

                            }
                            DispatchQueue.main.async {
                                
                                print("test 4")
                                self.tableView.reloadData()
                                //let indexPath = IndexPath(row: self.friendList.count - 1, section: 0)
                                //self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    
                    
                }
            }
    }
    
    
    
    
    
    
    
//    func loadPendingFriends(){
//
//        db.collection("friendList").document(UsersData().getCurrentUser())
//            .addSnapshotListener { (documentSnapshot, error) in
//                self.pendingFriendList = []
//                if let e = error{
//                    print(e)
//                } else{
//                if let document = documentSnapshot{
//                     let data = document.data()
//
//                    if data != nil{
//                        if let friends = data!["PendingFriends"]! as? [String]{
//                                for n in friends{
//                                    self.pendingFriendList.append(n)
//                                    DispatchQueue.main.async {
//                                        self.tableView.reloadData()
//                                    }
//
//                                }
//                            }
//                    }
//                    else{
//                        print("no pending friends")
//                    }
//
//                }
//            }
//    }
//}
    
    
}
