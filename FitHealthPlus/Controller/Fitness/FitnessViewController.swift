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
    
    let fitnessRef = Firestore.firestore().collection("fitness")
    
    let defaults = UserDefaults.standard
    
    var fitGoal: [FitGoal] = [FitGoal.init(caloriesBurn: 0, workoutTime: 0, steps: 0)]
    
    let dispatchGroup = DispatchGroup()
    
    let currentUser = UsersData().getCurrentUser()

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
        reloadFitnessGoals()
        
    }
}

extension FitnessViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            print("Hi 1")
            let cell = tableView.dequeueReusableCell(withIdentifier: "statsBar", for: indexPath) as! StatsBar
            tableView.rowHeight = 444
            
            let currentCal = Float(ActivityData().getDailyEnergyBurned())
            let currentSteps = Float(ActivityData().getDailySteps())
            let currentWorkout = Float(ActivityData().getDailySteps())
            
            let calGoal = fitGoal[0].caloriesBurn
            let stepGoal = fitGoal[0].steps
            let workoutGoal = fitGoal[0].workoutTime
            
            
            cell.caloriesProgress.progress = (currentCal / calGoal)
            cell.stepsProgress.progress = (currentSteps / stepGoal)
            cell.workoutTimeProgress.progress = (currentWorkout / workoutGoal)
            
            
            
            cell.dailyPrograssDetail.text = "\(currentWorkout)|\(workoutGoal)"
            cell.dailyPrograssDetail2.text = "\(currentSteps)|\(stepGoal)"
            cell.dailyPrograssdetail3.text = "\(currentCal)|\(calGoal)"
            
    
            
            
        
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
            
            setGoal()
            
        }
        else if indexPath.row == 1{
            self.performSegue(withIdentifier: "fitnessToGuide", sender: self)
            
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setGoal() {
        let alert = UIAlertController(title: "Goal", message: "Enter workout time", preferredStyle: .alert)
        var workoutGoal = UITextField()
        var stepGoal = UITextField()
        var calGoal = UITextField()
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let added = UIAlertController(title: "", message: "ADDED!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title:"OK", style: .default,handler: nil)
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (confirm) in
            
            
            if let workoutGoal = Float(workoutGoal.text!), let stepGoal = Float(stepGoal.text!),let calGoal = Float(calGoal.text!){
                self.fitGoal = []
                self.fitnessRef.document(self.currentUser).setData([K.FStore.calBurned : calGoal,
                                                               K.FStore.workoutTime: workoutGoal,
                                                               K.FStore.steps: stepGoal])
                print("Hi here ")
            }
            
            
            added.addAction(ok)
            self.present(added, animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        alert.addTextField { (text) in
            text.placeholder = "enter the workout goal"
            workoutGoal = text
        }
        alert.addTextField { (text) in
            text.placeholder = "enter the steps goal"
            stepGoal = text
        }
        alert.addTextField { (text) in
            text.placeholder = "enter the calories burned goal"
            calGoal = text
        }
        
        present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    
    
    
    
    func reloadFitnessGoals(){
        fitnessRef.document(UsersData().getCurrentUser()).addSnapshotListener { (doc, error) in
            
            self.fitGoal = []
            if let e = error{
                print("error getting fitness data \(e)")
            }else{
                
                guard let document = doc else{
                    print("error getting data 1")
                    return
                }
                guard let data = document.data() else{
                    print("error getting data 2")
                    return
                }
                print("Hi")
                let cal = data[K.FStore.calBurned] as! Float
                let steps = data[K.FStore.steps] as! Float
                let workoutTime = data[K.FStore.workoutTime] as! Float
                
                let tempGoal = FitGoal(caloriesBurn: cal, workoutTime: workoutTime, steps: steps)
                
                self.fitGoal.append(tempGoal)
                print(self.fitGoal)
                DispatchQueue.main.async {
                        self.tableView.reloadData()
                }
                }
                    
                }
                
            }

        
        
    
    
    
    
    
}

