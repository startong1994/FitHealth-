//
//  StatsBar.swift
//  FitHealth+
//
//  Created by xu daitong on 10/21/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class StatsBar: UITableViewCell,UITableViewDelegate {
    @IBOutlet weak var tableViewCell: UIView!
    @IBOutlet weak var workoutTimeText: UILabel!
    @IBOutlet weak var stepsText: UILabel!
    @IBOutlet weak var caloriesText: UILabel!
    @IBOutlet weak var workoutTimeProgress: UIProgressView!
    @IBOutlet weak var stepsProgress: UIProgressView!
    @IBOutlet weak var caloriesProgress: UIProgressView!
    
    
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = view.frame.size.height/10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func timeSelection(_ sender: UISegmentedControl) {

    }
    
    
}
