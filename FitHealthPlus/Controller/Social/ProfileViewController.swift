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
    
    var friend : FriendLists?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profileName.text = friend?.name
        profileEmail.text = friend?.email
        profileImage.image = UIImage(named: (friend?.profileImage)!)
        
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
               
               let delete = UIAlertAction(title: "Yes", style: .default){(delete) in
                   print("deleted")
               }
               
               let noDelete = UIAlertAction(title: "No!", style: .default){(delete) in
                   print("not deleted")
               }
               
               alert.addAction(delete)
               alert.addAction(noDelete)
               
               
               present(alert,animated: true,completion: nil)
        
    }
}
