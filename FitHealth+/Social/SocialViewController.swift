//
//  ForthViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/16/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var friends = ["Daitong Xu", "Fayliette", "Max Ries", "Catherine Cheatle", "J.R.", "Kendall Kling"]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Social"
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath)
        cell.textLabel?.text = friends[indexPath.row]
        
        return cell
        
    }
    
    

    
    
    
    


}

