//
//  CurrentUserViewController.swift
//  FitHealthPlus
//
//  Created by xu daitong on 11/17/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//
import UIKit
import FirebaseAuth


class CurrentUserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Profile"
        self.tabBarController?.tabBar.isHidden = true
        name.text = UsersData().getCurrentUser()
        email.text = UsersData().getCurrentEmail()
        profileImage.image = UIImage(named: UsersData().getCurrentProfileImage())
        //self.tableView.dataSource = self
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        print("logout pressed")
        do{
            try Auth.auth().signOut()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let welcomePageVC = storyBoard.instantiateViewController(withIdentifier: "WelcomePage") as! WelcomePageViewController
            
            
            self.navigationController?.pushViewController(welcomePageVC, animated: false)
        }catch let error as NSError{
            print("signing out error \(error)")
        }
    }
}
