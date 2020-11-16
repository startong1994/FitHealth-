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
    var pendingFriendList = [PendingLists]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        reload()
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Add Friends"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //loadPendingFriends()
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
        cell.textLabel?.text = pendingFriendList[indexPath.row].name
        cell.imageView?.image = UIImage(named: pendingFriendList[indexPath.row].profileImage!)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let pendingProfileVC = storyBoard.instantiateViewController(withIdentifier: "NewFriendProfile") as! NewFriendProfileViewController
        
        pendingProfileVC.pendingFriend = pendingFriendList[indexPath.row]
        print(pendingFriendList[indexPath.row])
        
        self.navigationController?.showDetailViewController(pendingProfileVC, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func reload(){
        db.collection("friendList").document(UsersData().getCurrentUser()).addSnapshotListener { (doc, error) in
            FriendNetwork().run(after: 1) {
                
                DispatchQueue.main.async {
                    self.pendingFriendList = FriendsData().loadPendingFriends()
                    self.tableView.reloadData()
                    print("pending reloaded")
                }
            }
            if let e = error{
                print("reloadFriendList* error \(e)")
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
