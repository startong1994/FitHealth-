//
//  LoginViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    let defaults = UserDefaults.standard
    
    let dispatchGroup = DispatchGroup()
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(ActivityData().getDailySteps())
        print(ActivityData().getDailyExercise())
        print(ActivityData().getDailyEnergyBurned())
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UINavigationBar.appearance().backgroundColor = UIColor.systemTeal
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    
    //signin
    @IBAction func signInPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }
                else{
                    //save current user's information to default file and navigate to next page
                    UsersData().storeCurrentUserData()
                    FriendNetwork().storeListsToUserDefaults(UsersData().getCurrentUser())
                    FriendNetwork().run(after: 1) {
                        self.performSegue(withIdentifier: "signinToMainPage", sender: self)
                    }
                }
            }
            
        }
    }
}
