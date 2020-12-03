//
//  RecipeMainViewController.swift
//  FitHealthPlus
//
//  Created by Catherine Cheatle on 11/28/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class RecipeMainViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //Page Components
    @IBOutlet weak var myRecipesBtn: UIButton!
    @IBOutlet weak var randomDish1Btn: UIButton!
    @IBOutlet weak var randomDish2Btn: UIButton!
    @IBOutlet weak var randomDish3Btn: UIButton!
    @IBOutlet weak var mainPageView: UIView!
    @IBOutlet weak var dietCollectionView: UICollectionView!
    @IBOutlet weak var mainCategoryCollectionView: UICollectionView!
    
    //Image Array for the Diet Categories
    var dietRestrictions = [UIImage(named: "no-salt")!, UIImage(named: "cholesterol")!, UIImage(named: "sugar")!, UIImage(named: "low-carb-diet")!, UIImage(named: "lactose-free")!, UIImage(named: "gluten-free")!, UIImage(named: "nut-free")!, UIImage(named: "vegetarian")!]
    var dietName = ["Low Sodium", "Low Cholesterol", "Low Sugar", "Low Carb", "Lactose Free", "Gluten Free", "Nut Free", "Vegetarian"]
    
    //Array for Main Category Collection View
    var mainCategoryName = ["Breakfast", "Lunch", "Dinner", "Desserts", "Poultry", "Beef", "Pork", "Seafood"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dietCollectionView.delegate = self
        dietCollectionView.dataSource = self
        mainCategoryCollectionView.delegate = self
        mainCategoryCollectionView.dataSource = self
        
        myRecipesBtn.layer.cornerRadius = 20
        randomDish1Btn.layer.cornerRadius = 0.5 * randomDish1Btn.bounds.size.width
        randomDish2Btn.layer.cornerRadius = 0.5 * randomDish2Btn.bounds.size.width
        randomDish3Btn.layer.cornerRadius = 0.5 * randomDish3Btn.bounds.size.width
        randomDish1Btn.clipsToBounds = true
        randomDish2Btn.clipsToBounds = true
        mainPageView.setTwoGradient(colorOne: UIColor.systemTeal, colorTwo: UIColor.white)
        dietCollectionView.backgroundColor = UIColor.clear
        mainCategoryCollectionView.backgroundColor = UIColor.clear
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        //searchController.navigationItem.hidesSearchBarWhenScrolling = true
        let searchBar = UISearchBar(frame: CGRect.init(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchController.searchBar.delegate = self
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemTeal
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.dietCollectionView {
            return dietRestrictions.count
        }
        
        return mainCategoryName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.dietCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dietCategoryCell", for: indexPath) as! dietCategoryCollectionViewCell
            cell.dietCategoryImage.contentMode = .scaleAspectFit
            cell.dietCategoryImage.clipsToBounds = true
            cell.dietCategoryImage.image = dietRestrictions[indexPath.row]
            cell.dietCategoryLabel.text = dietName[indexPath.row]
            return cell
        }
        
        else{
            let mcell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCategoryCell", for: indexPath) as! mainCategoryCollectionViewCell
            mcell.mainCategoryLabel.text = mainCategoryName[indexPath.row]
            //mcell.backgroundColor = UIColor.systemBlue
            mcell.layer.cornerRadius = 20
            return mcell
        }
    }
    

}

extension UIView {
    public func setTwoGradient(colorOne: UIColor, colorTwo: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

class dietCategoryCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var dietCategoryImage: UIImageView!
    @IBOutlet weak var dietCategoryLabel: UILabel!
}

class mainCategoryCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var mainCategoryLabel: UILabel!
}
