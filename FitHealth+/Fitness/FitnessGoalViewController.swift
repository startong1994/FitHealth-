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
        tableView.rowHeight = 320
        tableView.register(UINib(nibName: "FitnessGoalTableViewCell", bundle: nil), forCellReuseIdentifier: "fitnessGoalCell")
    }


}

extension FitnessGoalViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "fitnessGoalCell", for: indexPath) as! FitnessGoalTableViewCell
        if indexPath.row == 0{
            cell.fitnessCurrent.text = "Current: 14"
            cell.fitnessGoal.text = "Goal: 30"
            cell.fitnessGoalTitle.text = "Daily Workout Time"
            cell.progressBar.progress = 14/30
        }
        else if indexPath.row == 1{
            cell.fitnessCurrent.text = "Current: 731"
            cell.fitnessGoal.text = "Goal: 1000"
            cell.fitnessGoalTitle.text = "Daily steps"
            cell.progressBar.progress = 731/1000
        }
        else if indexPath.row == 2{
            cell.dataType.text = "In Calories"
            cell.fitnessCurrent.text = "Current: 333"
            cell.fitnessGoal.text = "Goal: 500"
            cell.fitnessGoalTitle.text = "Calories Borned"
            cell.progressBar.progress = 333/500
        }
            
        return cell
    }
    
    
}
