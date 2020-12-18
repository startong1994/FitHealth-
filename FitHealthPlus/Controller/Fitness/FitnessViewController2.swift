//
//  FitnessViewController2.swift
//  FitHealthPlus
//
//  Created by xu daitong on 12/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FitnessViewController2: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentWorkoutTime: UILabel!
    @IBOutlet weak var currentSteps: UILabel!
    @IBOutlet weak var currentCaloriesBurned: UILabel!
    @IBOutlet weak var MyGoal: UILabel!
    @IBOutlet weak var CurrentChallenge: UILabel!
    @IBOutlet weak var caloriesProgress: UIProgressView!
    @IBOutlet weak var stepsProgress: UIProgressView!
    @IBOutlet weak var workoutTimeProgress: UIProgressView!
    @IBOutlet weak var challengePending: UIButton!
    
    
    let db = Firestore.firestore()
    
    
    
    
    var fitGoal: [FitGoal] = [FitGoal.init(caloriesBurn: 0, workoutTime: 0, steps: 0)]
    var challengeList : [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Fitness"
        tableView.tableFooterView = UIView()
        getGoals()
        checkForUpdates()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func getGoals(){
        db.collection("fitnessGoal").document(UsersData().getCurrentUser()).addSnapshotListener { (DocumentSnapshot, error) in
            self.fitGoal = []
            if let error = error{
                print("error getting document\(error)")
            }else{
                guard let doc = DocumentSnapshot else {
                    print("error2 ")
                    return
                }
                guard let data = doc.data() else {
                    print("error getting data")
                    return
                }
                let workoutGoal = data[K.FStore.workoutTime] as! Float
                let steps = data[K.FStore.steps] as! Float
                let caloriesBurn = data[K.FStore.calBurned] as! Float
                
                let tempGoal = FitGoal(caloriesBurn: caloriesBurn, workoutTime: workoutGoal, steps: steps)
        
                self.fitGoal.append(tempGoal)
                DispatchQueue.main.async {
                    self.loadGoals()
                    print(self.fitGoal)
                }
                
            }
        }
    }
    
    func loadGoals(){
        let currentCal = Float(ActivityData().getDailyEnergyBurned())
        let currentStep = Float(ActivityData().getDailySteps())
        let currentWorkout = Float(ActivityData().getDailySteps())
        
        let calGoal = fitGoal[0].caloriesBurn
        let stepGoal = fitGoal[0].steps
        let workoutGoal = fitGoal[0].workoutTime
        
        
        
        
        caloriesProgress.progress = (currentCal / calGoal)
        stepsProgress.progress = (currentStep / stepGoal)
        workoutTimeProgress.progress = (currentWorkout / workoutGoal)
    
        
        currentWorkoutTime.text = "\(currentWorkout)|\(workoutGoal)"
        currentSteps.text = "\(currentStep)|\(stepGoal)"
        currentCaloriesBurned.text = "\(currentCal)|\(calGoal)"
        
        
    }
    
    
    
    
    @IBAction func setGoalButtonPressed(_ sender: UIButton) {
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
                let currentUserRef = self.db.collection("fitnessGoal").document(UsersData().getCurrentUser())
                currentUserRef.setData([K.FStore.calBurned : calGoal,
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
    
    
    

}




extension FitnessViewController2: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeListCell", for: indexPath)
        cell.textLabel?.text = challengeList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.count > 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            
            
            let profileVC = storyBoard.instantiateViewController(withIdentifier: "leaderBoard") as! LeaderboardViewController
            
            profileVC.challengeName = challengeList[indexPath.row]
            print(challengeList[indexPath.row])
            
            self.navigationController?.pushViewController(profileVC, animated: true)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    }
    
    func checkForUpdates(){
        db.collection("challengeList").document(UsersData().getCurrentUser()).addSnapshotListener { (doc, error) in
            if let error = error{
                print("\(error)")
            }else{
                self.reload()
            }
        }
    }
    
    
    func reload(){
        db.collection("challengeList").document(UsersData().getCurrentUser()).getDocument{(document, error) in
            if let error = error{
                print("error getting document\(error)")
            }else{
                guard let doc = document else{
                    print("error getting doc")
                    return
                }
                guard let data = doc.data() else{
                    print("error getting data")
                    return
                }
                if let list = data[K.FStore.challengeName] as? [String]{
                    self.challengeList = list
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                }
            }
        }
    }
    
}

