//
//  LeaderboardViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import CoreData
import FirebaseFirestore

class LeaderboardViewController: UIViewController {

    let db = Firestore.firestore()
    
    var challengeFriends : [String : Int] = [:]
    var challengeFriendsName : [String] = []
    var challengeProgress : [Int] = []
    var challengeCreater: String = ""
    var challengeGoal: Int = 0
    var challengeExpireTime: String = ""
    
    @IBOutlet weak var progressL: UILabel!
    @IBOutlet weak var creater: UILabel!
    @IBOutlet weak var expires: UILabel!
    @IBOutlet weak var goals: UILabel!
    @IBOutlet weak var challengePressView: UIProgressView!
    
    
    
    
    
    
    
    
    
    var challengeName : String = ""
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Detail"
        
        //self.tableView.dataSource = self
    
        name.text = challengeName
        
        reload()
    }
    
    func reload() {
        
        db.collection("challenge").document(challengeName).getDocument { (doc, error) in
            if let error = error{
                print("error getting collection \(error)")
            }else{
                guard let data = doc?.data() else {
                    print("error getting challenge name")
                    return
                }
                if let goal = data[K.FStore.challengeGoal] as? Int{
                    self.challengeGoal = goal
                    self.goals.text = "Goal: \(goal)"
                }
                if let expireTime = data[K.FStore.challengeExpireTime] as? String{
                    self.challengeExpireTime = expireTime
                    self.expires.text = "End By : \(expireTime)"
                }
                if let creater = data[K.FStore.challengeCreater] as? String{
                    self.challengeCreater = creater
                    self.creater.text = "Created By \(creater)"
                    
                    let i = self.challengeName.count - (creater.count + 4)
                    let tempName = self.challengeName.prefix(i)
                    
                    self.name.text = String(tempName)
                    
                }
                
                if let friends = data[K.FStore.challengeFriends] as? [String]{
                    for friend in friends{
                        self.db.collection("challengeProgress").document(friend).getDocument { (doc, error) in
                            if let error = error{
                                print("error getting collection \(error)")
                            }else{
                                guard let doc = doc else {
                                    print("error getting friend's progress")
                                    return
                                }
                                guard let data = doc.data() else{
                                    print("error getting data")
                                    return
                                }
                                if let progress = data[K.FStore.challengeProgress] as? Int{
                                    self.challengeFriends[friend] = progress
                                    if UsersData().getCurrentUser() == friend{
                                        self.progressL.text = String(progress)
                                    }
                                }else{
                                    self.challengeFriends[friend] = 0
                                    if UsersData().getCurrentUser() == friend{
                                        self.progressL.text = ("Current: 0")
                                    }
                                }
                            }
                        }
                        
                        
                    }
                }
                
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
                    
                }
            }
        }
    
    
    
    
    
}

extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate{

    //get rows in data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeFriends.count
    }
    //return the data to row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
       
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath)
            cell.textLabel?.text = challengeFriendsName[indexPath.row]
            cell.imageView?.image = UIImage(named: "1.circle.fill")
            cell.detailTextLabel?.text = String(challengeProgress[indexPath.row])
            tableView.rowHeight = 120
            return cell
        }
        else if indexPath.row == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "second", for: indexPath)
            cell.textLabel?.text = challengeFriendsName[indexPath.row]
            cell.imageView?.image = UIImage(named: "2.circle")
            cell.detailTextLabel?.text = String(challengeProgress[indexPath.row])
            tableView.rowHeight = 80
            return cell
        }
        else if indexPath.row == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: "third", for: indexPath)
            cell.textLabel?.text = challengeFriendsName[indexPath.row]
            cell.imageView?.image = UIImage(named: "3.circle")
            cell.detailTextLabel?.text = String(challengeProgress[indexPath.row])
            tableView.rowHeight = 60
            return cell
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "after", for: indexPath)
            cell.textLabel?.text = challengeFriendsName[indexPath.row]
            cell.detailTextLabel?.text = String(challengeProgress[indexPath.row])
            tableView.rowHeight = 44
            return cell
        }

    }

}
    
