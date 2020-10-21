//
//  FirstViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/16/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class FitnessViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        
        tableView.register(UINib(nibName: "StatsBar", bundle: nil), forCellReuseIdentifier: "statsBar")
        tableView.register(UINib(nibName: "workoutCell", bundle: nil), forCellReuseIdentifier: "workoutBar")
        
        
    }
}

extension FitnessViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutBar", for: indexPath) as! workoutCell
            tableView.rowHeight = 444
            
            return cell
        
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "statsBar", for: indexPath) as! StatsBar
            tableView.rowHeight = 444
            
            return cell
            
        }

    }
    
    
    
    
}

