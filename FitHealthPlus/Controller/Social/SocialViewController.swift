//
//  ForthViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/16/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CoreData

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var usersRef = Firestore.firestore().collection("users")
    var friendsRef = Firestore.firestore().collection("friendList")
    let currentUser = UsersData().getCurrentUser()
    let defaults = UserDefaults.standard
    
    
    var friendList = [Friend]()
    
    
    lazy var refresh: UIRefreshControl = {
        let refControl = UIRefreshControl()
        refControl.tintColor = .systemBlue
        refControl.addTarget(self, action: #selector(tableReload), for: .valueChanged)
        
        return refControl
        
    }()
    
    
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        
        tableView.refreshControl = refresh
        listenToOnlineDatabaseChanges()
        
        
        self.tableView.tableFooterView = UIView()
        navigationItem.title = "Social"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    @objc func tableReload(){
        print("Hi")
        let timeout = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: timeout) {
            self.refresh.endRefreshing()
            self.friendList = []
            self.reload()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //reload()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("table view reload works count number of rows")
        print(friendList.count)
        return friendList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath)
        if friendList.count > 0{
            let name  = friendList[indexPath.row].name
            let image = friendList[indexPath.row].profileImage
            cell.textLabel?.text = name
            cell.imageView?.image = UIImage(named: image)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.count > 0{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let profileVC = storyBoard.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
            
            profileVC.friend = friendList[indexPath.row]
            print(friendList[indexPath.row])
            
            self.navigationController?.pushViewController(profileVC, animated: true)
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }

    }
    
    
    @IBAction func addFriendButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "socialToPendingList", sender: self)
        /*
         codes for add friends.
         */
//        let alert = UIAlertController(title: "Add Friend", message: "", preferredStyle: .alert)
//        let added = UIAlertController(title: "", message: "Added, Pull to Refresh! :D", preferredStyle: .alert)
//
//        var emailAddress = UITextField()
//
//
//        //ok botton for conformation alert pop up
//        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//
//
//        //confirm button function
//        let addFriend = UIAlertAction(title: "Confirm", style: .default) { (addFriend) in
//            if let address = emailAddress.text {
//                if address.hasSuffix("uncc.edu"){
//                print(address + " added")
//
//
//                //add friends
//
//                    FriendNetwork().addFriend(Email: address)
//
//
//                added.addAction(ok)
//
//                self.present(added, animated: true, completion: nil)
//                }else{
//                    let alert = UIAlertController(title: "Error", message: "Please Enter UNCC School Email", preferredStyle: .alert)
//
//                    alert.addAction(ok)
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }
//        alert.addAction(addFriend)
//        //cancel button
//        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//
//        alert.addTextField { (textField) in
//            textField.placeholder = "Enter Email Address"
//            emailAddress = textField
//        }
//        alert.addAction(cancel)
//
//        alert.preferredAction = addFriend
//        present(alert,animated: true, completion: nil)
        
    }
    
    
    func listenToOnlineDatabaseChanges(){
        
        friendsRef.document(UsersData().getCurrentUser()).addSnapshotListener { (DocumentSnapshot, error) in
            if let error = error{
                print("error getting friendList collcection \(error)")
            }
            
            FriendNetwork().storeFriendsListToUserDefaults()
            
            FriendNetwork().run(after: 1) {
                self.reload()
            }
    }
    }
    
    
    
    
    
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "socialToCurrentUser", sender: self)
    }

    
    func reload(){

        FriendNetwork().storeFriendsListToUserDefaults()

        guard let listArray = defaults.array(forKey: K.FStore.FriendList) as? [String] else {
            print("no friends")
            return
        }


        friendList = []
        if listArray.isEmpty{
            tableView.reloadData()
            }

        for emails in listArray {


            self.usersRef.document(emails).getDocument { (doc, error) in
                if let e = error {
                    print(e)
                }else{
                    guard let document = doc else {
                        return
                    }
                    guard let data = document.data() else{
                        print("test")
                        return
                    }
                        if let friendName = data["name"] as? String, let friendEmail = data["email"] as? String, let friendImge = data["profileImage"] as? String{
                            print("test3")
                            let list = Friend(name: friendName, email: friendEmail, profileImage: friendImge)
                            self.friendList.append(list)

                        }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }


            }


        }


    }













//    func reload(){
//        if let friendsEmail = UserDefaults.standard.array(forKey: K.FStore.FriendList) as? [String]{
//
//
// //           self.friendsRef.document(currentUser).addSnapshotListener { (doc, error) in
////                if let e = error{
////                    print(e)
////                } else{
//                self.friendList = []
//
//                if friendsEmail.isEmpty{
//                tableView.reloadData()
//                }
//
//                    print("test1  \(friendsEmail)")
//
//                    for emails in friendsEmail{
//                        self.usersRef.document(emails).getDocument { (doc, error) in
//                            print("test2")
//                            if let e = error{
//                                print(e)
//                                }else{
//                                guard let document = doc else {
//                                    return
//                                }
//                                guard let data = document.data() else {
//                                    return
//                                }
//                                if let friendName = data["name"] as? String, let friendEmail = data["email"] as? String, let friendImge = data["profileImage"] as? String{
//                                    print("test3")
//                                    let list = Friend(name: friendName, email: friendEmail, profileImage: friendImge)
//                                    self.friendList.append(list)
//                                }
//
//                            }
//                            DispatchQueue.main.async {
//
//                                print("test 4")
//                                self.tableView.reloadData()
//                                //let indexPath = IndexPath(row: self.friendList.count - 1, section: 0)
//                                //self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                            }
//                        }
//
//
//                }
//            }
//            //}
//
//        }
//
    //}
//        db.collection("friendList").document(UsersData().getCurrentUser()).addSnapshotListener { (doc, error) in
//            FriendNetwork().run(after: 1) {
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                    print("reloaded")
//
//                }
//            }
//            if let e = error{
//                print("reloadFriendList* error \(e)")
//            }
//    }



    
    
    
}
