//
//  FitnessGoalTableViewCell.swift
//  FitHealth+
//
//  Created by xu daitong on 10/21/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class FitnessGoalTableViewCell: UITableViewCell {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var fitnessGoalTitle: UILabel!
    @IBOutlet weak var fitnessCurrent: UILabel!
    @IBOutlet weak var fitnessGoal: UILabel!
    @IBOutlet weak var dataType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 20)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        print("presed")
        
    }
    
}
