//
//  FitnessGoal.swift
//  FitHealth+
//
//  Created by xu daitong on 10/21/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class FitnessGoalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        
        tableView.register(UINib(nibName: "FitnessGoalTableViewCell", bundle: nil), forCellReuseIdentifier: "fitnessGoalCell")
    }


}

extension FitnessGoalViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3{
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fitnessGoalCell", for: indexPath) as! FitnessGoalTableViewCell
        tableView.rowHeight = 320
        
        return cell
    }
    
    
}
