//
//  ProfileViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/20/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    //let friend = FriendsData()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    
    var friend : Friend?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.tabBarItem.title = "Profile"
        loadProfile()
        
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
               
               let delete = UIAlertAction(title: "Yes", style: .default){(delete) in
                if let email = self.friend?.email, let name = self.friend?.name{
                    print("deleted \(email)")
                    FriendNetwork().deleteFriend(friendEmail: email, friendName: name)
                }
                   print("deleted")
               }
               
               let noDelete = UIAlertAction(title: "No!", style: .default){(delete) in
                   print("not deleted")
               }
               
               alert.addAction(delete)
               alert.addAction(noDelete)
               
               
               present(alert,animated: true,completion: nil)
        
    }
    
    func loadProfile(){
        
        if let image = friend?.profileImage, let name = friend?.name,
           let email = friend?.email{
            profileName.text = name
            profileEmail.text = email
            profileImage.image  = UIImage(named: image)
            
        }
        
        
        
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "socialToProfile", sender: self)
    }
}
