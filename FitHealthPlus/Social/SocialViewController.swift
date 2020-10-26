//
//  ForthViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/16/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var index = 0
    var friend = FriendsData()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
        navigationItem.title = "Social"
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend.friendData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileImage = friend.getProfileImage(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath)
        cell.textLabel?.text = friend.getName(indexPath.row)
        cell.imageView?.image = UIImage(named: profileImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        
        performSegue(withIdentifier: "socialToProfile", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "socialToProfile" {
            let profileVC = segue.destination as! ProfileViewController
            let indexPath = index
            profileVC.index = indexPath
            
        }
    }

    
    
    
    


}

