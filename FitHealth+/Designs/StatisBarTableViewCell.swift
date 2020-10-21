//
//  StatisBarTableViewCell.swift
//  FitHealth+
//
//  Created by xu daitong on 10/21/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class StatusBarTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var statisView: StatusBarTableViewCell!
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
        statisView.layer.cornerRadius = statisView.frame.size.height/10
        
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
    
    
}
