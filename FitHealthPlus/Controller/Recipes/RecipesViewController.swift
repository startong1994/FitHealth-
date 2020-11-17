//
//  SecondViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/16/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {
 //
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recipies"
        
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    


}

