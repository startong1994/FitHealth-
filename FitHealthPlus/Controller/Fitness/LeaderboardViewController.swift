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
                }
                if let expireTime = data[K.FStore.challengeExpireTime] as? String{
                    self.challengeExpireTime = expireTime
                }
                if let creater = data[K.FStore.challengeCreater] as? String{
                    self.challengeCreater = creater
                }
                if let friends = data[K.FStore.challengeFriends] as? [String]{
                    for friend in friends{
                        print(friend)
                    }
                    
                }
                    
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
    
