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
        
        FriendsDataTester().storeListsToUserDefaults(UsersData().getCurrentUser())
        self.tableView.tableFooterView = UIView()
        navigationItem.title = "Social"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        friendList = FriendsDataTester().loadFriendList()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath)
        cell.textLabel?.text = friendList[indexPath.row].name!
        cell.imageView?.image = UIImage(named: friendList[indexPath.row].profileImage!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        
        profileVC.friend = friendList[indexPath.row]
        print(friendList[indexPath.row])
        
        self.navigationController?.showDetailViewController(profileVC, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)

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

