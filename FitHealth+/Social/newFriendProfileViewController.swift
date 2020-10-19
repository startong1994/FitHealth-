//
//  newFriendProfileViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/19/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class newFriendProfileViewController: UIViewController {
    let friend = FriendsData()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profileImage?.image = UIImage(named: friend.getNewFriendProfileImage(0))
        profileName?.text = friend.getNewFriendName(0)
        profileEmail.text = friend.getNewFriendEmail(0)
        
    }
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        print("Accpeted")
    }
    
    @IBAction func rejectButtonPressed(_ sender: UIButton) {
        print("Rejected")
    }
    


}
