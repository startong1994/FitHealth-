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
        self.tableView.delegate = self
        
        tableView.rowHeight = 320
        tableView.register(UINib(nibName: "FitnessGoalTableViewCell", bundle: nil), forCellReuseIdentifier: "fitnessGoalCell")
    }


}

extension FitnessGoalViewController: UITableViewDataSource, UITableViewDelegate{
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
    
    //if one of the row has been selected, pop up alert to edit the goal
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
            print(getGoal("Daily Workout Time"))
        }
        else if indexPath.row == 1{
            print(getGoal("Daily steps"))
        }
        else if indexPath.row  == 2{
            print(getGoal("Calories Borned"))
        }
        
    }
    
    
    
    //should be able to return the Float number,
    func getGoal(_ t: String) -> Float {
        let alert = UIAlertController(title: "Goal", message: "Enter " + t, preferredStyle: .alert)
        var goalText = UITextField() // holder for goalText
        // cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        // OK button
        let ok = UIAlertAction(title:"OK", style: .default,handler: nil)
        // display added
        let added = UIAlertController(title: "", message: "ADDED!", preferredStyle: .alert)
        // alert user to enter INT
        let alertInt = UIAlertController(title: "", message: "Please enter a number", preferredStyle: .alert)
        
        
        // confirm button functions
        let confirm = UIAlertAction(title: "Confirm", style: .default){
            (confirm) in
            if let goal = goalText.text{
                //if goal is not int
                if !goal.isInt{
                    alertInt.addAction(ok)
                    self.present(alertInt, animated: true, completion: nil)
                }
                else{
                    print(goal + " goal")
                    added.addAction(ok)
                    self.present(added, animated: true, completion: nil)
                }
            
                
            }
        }
        
        
        
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        alert.addTextField { (textField) in
            goalText = textField
        }
        
        
        
        present(alert,animated: true, completion: nil)
        
        
        
        
        
        
        
        return 0
        
    }
    
    

}


//check if the string is int or not
extension String{
    var isInt: Bool{
        return Int(self) != nil
    }
}
