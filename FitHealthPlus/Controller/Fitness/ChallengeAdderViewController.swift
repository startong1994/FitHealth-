//
//  ChallengeAdderViewController.swift
//  FitHealthPlus
//
//  Created by xu daitong on 12/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ChallengeAdderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var friendList :[String] = []
    var challengeFriendList : [String] = []
    let defaults = UserDefaults.standard
    @IBOutlet weak var ChallengeName: UITextField!
    @IBOutlet weak var challengeQuantity: UITextField!
    @IBOutlet weak var expireTime: UITextField!
    
    
    
    let db = Firestore.firestore()
    private var datePicker: UIDatePicker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriendList()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelection = true
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ChallengeAdderViewController.dateChanged(datePicker: )), for: .valueChanged)

//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChallengeAdderViewController.viewTap(gestureRecognizer:)))


//        view.addGestureRecognizer(tapGesture)


        expireTime.inputView = datePicker
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"

        expireTime.text = dateFormat.string(from: datePicker.date)
        view.endEditing(true)
    }
    @objc func viewTap(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        
        if let chanllengeGoal = challengeQuantity.text, let expireTime = expireTime.text, let challengeName = ChallengeName.text{
            
            let docName = String(challengeName + " By " + UsersData().getCurrentUser())
            
            db.collection("challenge").document(docName).getDocument { (document, error) in
                if let error = error{
                    print("error \(error)")
                }else{
                    if document?.exists == true{
                        print("exitst")
                    }else{
                        self.db.collection("challenge").document(docName).setData(["challengeName" : challengeName,
                                                                                                    "expireTime": expireTime,
                                                                                                    "creater": UsersData().getCurrentUser(),
                                                                                                    "challengeGoal": Int(chanllengeGoal)!, K.FStore.challengeFriends:[ UsersData().getCurrentUser()]])
                        ChallengeNetwork().addChallenge(docName)
                        ChallengeNetwork().challengeRequestSent(self.challengeFriendList, docName)
                    }
                    
                }
            }
            
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
}


//friends list
extension ChallengeAdderViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath)
        cell.textLabel?.text = friendList[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(friendList[indexPath.row])
        var i: Int
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            i = 0
            for name in challengeFriendList{
                if name == friendList[indexPath.row]{
                    print(i)
                    challengeFriendList.remove(at: i)
                }
                i += 1
            }
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            challengeFriendList.append(friendList[indexPath.row])
        }


        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func loadFriendList(){
        guard let emailList = defaults.array(forKey: K.FStore.FriendList) as? [String] else{
            print("no friend List")
            return
        }
        friendList = []
        if emailList.isEmpty{
            tableView.reloadData()
            }
        for emails in emailList {
            self.db.collection("users").document(emails).getDocument { (doc, error) in
                if let e = error {
                    print(e)
                }else{
                    guard let document = doc else {
                        return
                    }
                    guard let data = document.data() else{
                        print("test")
                        return
                    }
                        if let friendName = data["name"] as? String{
                            print("test3")
                            self.friendList.append(friendName)
                        }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }

    }
    
    
    
    
}
