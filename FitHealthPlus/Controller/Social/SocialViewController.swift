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
    
    var db = Firestore.firestore()

    var friendList = [FriendLists]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //load friend list
        reload()
        self.tableView.tableFooterView = UIView()
        navigationItem.title = "Social"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("table view reload works count number of rows")
        print(friendList)
        print(friendList.count)
        return friendList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath)
        print("tableview reload works 2")
        if indexPath.row >= 0{
            if let name  = friendList[indexPath.row].name, let image = friendList[indexPath.row].profileImage
            {
                cell.textLabel?.text = name
                cell.imageView?.image = UIImage(named: image)
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        
        profileVC.friend = friendList[indexPath.row]
        print(friendList[indexPath.row])
        
        self.navigationController?.pushViewController(profileVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func reload(){
        db.collection("friendList").document(UsersData().getCurrentUser()).addSnapshotListener { (doc, error) in
            FriendNetwork().run(after: 1) {
                
                DispatchQueue.main.async {
                    self.friendList = FriendsData().loadFriendList()
                    self.tableView.reloadData()
                    print("reloaded")
                    
                }
            }
            if let e = error{
                print("reloadFriendList* error \(e)")
            }
    }
    }
    
    
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "socialToCurrentUser", sender: self)
    }
    
    
    
    
//    func loadFriends(){
//
//        db.collection("friendList").document(UsersData().getCurrentUser())
//            .addSnapshotListener { (documentSnapshot, error) in
//                self.friendList = []
//
//                //FriendsDataTester().storeFriendList()
//                //FriendsDataTester().removeFriend(0)
//
//                if let e = error{
//                    print(e)
//                }
//                else{
//                if let document = documentSnapshot{
//                    let data = document.data()
//                    if data != nil{
//                        guard let friends = data!["FriendList"]! as? [String] else{
//                            print("no friends")
//                            return
//                        }
//                        for n in friends{
//                            self.friendList.append(n)
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                                }
//                                }
//                            }
//                        else{
//                            print("no friends")
//                    }
//                        }
//                }
//            }
//        print(friendList)
//    }
}

