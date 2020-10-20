//
//  LeaderboardViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    let friend = FriendsData()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.title = "LeaderBoard"
        
        self.tableView.dataSource = self
        
        
    }
    
}



extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate{
    
    //get rows in data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend.friendData.count
    }
    //return the data to row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath)
            cell.textLabel?.text = friend.getName(indexPath.row)
            cell.imageView?.image = UIImage(named: "1.circle.fill")
            cell.detailTextLabel?.text = String(friend.getSteps(indexPath.row))  + " Steps"
            
            return cell
        }
        else if indexPath.row == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "second", for: indexPath)
            cell.textLabel?.text = friend.getName(indexPath.row)
            cell.imageView?.image = UIImage(named: "2.circle")
            cell.detailTextLabel?.text = String(friend.getSteps(indexPath.row)) + " Steps"
            return cell
        }
        else if indexPath.row == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: "third", for: indexPath)
            cell.textLabel?.text = friend.getName(indexPath.row)
            cell.imageView?.image = UIImage(named: "3.circle")
            cell.detailTextLabel?.text = String(friend.getSteps(indexPath.row))  + " Steps"
            return cell
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "after", for: indexPath)
            cell.textLabel?.text = friend.getName(indexPath.row)
            cell.detailTextLabel?.text = String(friend.getSteps(indexPath.row))  + " Steps"
            return cell
        }
        
    }
    
}
