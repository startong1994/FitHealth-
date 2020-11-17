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
    @IBOutlet weak var myRecipesButton: UIButton!
    @IBOutlet weak var ltFeaturedRecipeButton: UIButton!
    @IBOutlet weak var rtFeaturedRecipeButton: UIButton!
    @IBOutlet weak var recipeButton1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recipes"
        myRecipesButton.layer.cornerRadius = 6
        rtFeaturedRecipeButton.layer.cornerRadius = 6
        ltFeaturedRecipeButton.layer.cornerRadius = 6
        recipeButton1.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    


}

