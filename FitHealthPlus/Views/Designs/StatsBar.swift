//
//  StatsBar.swift
//  FitHealth+
//
//  Created by xu daitong on 10/21/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class StatsBar: UITableViewCell,UITableViewDelegate {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var workoutTimeText: UILabel!
    @IBOutlet weak var stepsText: UILabel!
    @IBOutlet weak var caloriesText: UILabel!
    @IBOutlet weak var workoutTimeProgress: UIProgressView!
    @IBOutlet weak var stepsProgress: UIProgressView!
    @IBOutlet weak var caloriesProgress: UIProgressView!
    @IBOutlet weak var workoutBar: UIProgressView!
    @IBOutlet weak var stepsBar: UIProgressView!
    @IBOutlet weak var calBar: UIProgressView!
    @IBOutlet weak var dailyPrograssDetail: UILabel!
    @IBOutlet weak var dailyPrograssDetail2: UILabel!
    @IBOutlet weak var dailyPrograssdetail3: UILabel!
    
    
    let workoutText = "workout time: current/goal"
    let stepText = "steps: current/goal"
    let calText = "calories borned: current/goal"

    
    
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        let calGoal = FitnessViewController().fitGoal[0].caloriesBurn
        let stepsGoal = FitnessViewController().fitGoal[0].steps
        let workoutGoal = FitnessViewController().fitGoal[0].workoutTime
        
        let currentCal = Float(ActivityData().getDailyEnergyBurned())
        let currentSteps = Float(ActivityData().getDailySteps())
        let currentWorkout = Float(ActivityData().getDailyExercise())
        
        
        view.layer.cornerRadius = view.frame.size.height/10
        workoutTimeText.text = "daily " + workoutText
        stepsText.text = "daily " + stepText
        caloriesText.text = "daily " + calText
        dailyPrograssDetail.text = "\(currentWorkout)|\(workoutGoal)"
        dailyPrograssDetail2.text = "\(currentSteps)|\(stepsGoal)"
        dailyPrograssdetail3.text = "\(currentCal)|\(calGoal)"
        
        
        
        
        
        workoutBar.transform = workoutBar.transform.scaledBy(x: 1, y: 5)
        stepsBar.transform = stepsBar.transform.scaledBy(x: 1, y: 5)
        calBar.transform = calBar.transform.scaledBy(x: 1, y: 5)
        
        
        
        
        
        caloriesProgress.progress = (currentCal / calGoal)
        stepsProgress.progress = (currentSteps / stepsGoal)
        workoutTimeProgress.progress = (currentWorkout / workoutGoal)
        


        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        
        

        
        if segmentControl.selectedSegmentIndex == 0{
            workoutTimeText.text = "daily " + workoutText
            stepsText.text = "daily " + stepText
            caloriesText.text = "daily " + calText
            workoutTimeProgress.progress = 14/30
            caloriesProgress.progress = 333/500
            stepsProgress.progress = 731/1000
        }
        else if segmentControl.selectedSegmentIndex == 1{
            workoutTimeText.text = "weekly " + workoutText
            stepsText.text = "weekly " + stepText
            caloriesText.text = "weekly " + calText
            workoutTimeProgress.progress = 0.2
            caloriesProgress.progress = 0.3
            stepsProgress.progress = 0.5
            
        }
        else if segmentControl.selectedSegmentIndex == 2{
            workoutTimeText.text = "monthly " + workoutText
            stepsText.text = "monthly " + stepText
            caloriesText.text = "monthly " + calText
            workoutTimeProgress.progress = 0.6
            caloriesProgress.progress = 0.7
            stepsProgress.progress = 0.8
            
        }
        else{
            print(" no way to select other than 0-2 index!")
        }
        
    }
    
}
