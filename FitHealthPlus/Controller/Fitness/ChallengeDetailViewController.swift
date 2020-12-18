//
//  ChallengeDetailViewController.swift
//  FitHealthPlus
//
//  Created by xu daitong on 12/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class ChallengeDetailViewController: UIViewController {
    @IBOutlet weak var challengeName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        print("deleteButton pressed")
    }
    
}
