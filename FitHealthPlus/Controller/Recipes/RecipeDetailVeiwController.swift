//
//  RecipeDetailVeiwController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/23/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit


class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var titleOfRecipe: UILabel!
    @IBOutlet weak var imageOfRecipe: UIImageView!
    @IBOutlet weak var ServingSizeOfRecipe: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Recipe"
        self.tableView.dataSource = self
        
        imageOfRecipe.image = UIImage.init(named: "chicken parmesan")
        
        tableView.register(UINib(nibName: "RecipeDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeDetailCell")
        
        
        
        
    }
    


}

extension RecipeDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "recipeDetailCell", for: indexPath) as! RecipeDetailTableViewCell
        tableView.rowHeight = 700
        
        
        
        return cell
        
    }
    
    
    
}
