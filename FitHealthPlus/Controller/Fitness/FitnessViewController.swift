//
//  FirstViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/16/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import Firebase

class FitnessViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.register(UINib(nibName: "StatsBar", bundle: nil), forCellReuseIdentifier: "statsBar")
        tableView.register(UINib(nibName: "workoutCell", bundle: nil), forCellReuseIdentifier: "workoutBar")
        
        
        
        //first tab after login or sign in, so set Current user's data to local default data
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //get user's name with line 16,
        
    }
}

extension FitnessViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "statsBar", for: indexPath) as! StatsBar
            tableView.rowHeight = 444
        
            return cell
            
        
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutBar", for: indexPath) as! workoutCell
            tableView.rowHeight = 444
            
            return cell
            
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "fitnessToGoal", sender: self)
        }
        else if indexPath.row == 1{
            self.performSegue(withIdentifier: "fitnessToGuide", sender: self)
            
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
}

