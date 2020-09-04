//
//  UserConfirmViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/1/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class UserConfirmViewController: UIViewController {
    
    //MARK: - Interface Outlets
    
    @IBOutlet var confirmViewBox: UIView!
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var confirmComments: UITextView!
    @IBOutlet var serviceDateLabel: UILabel!
    @IBOutlet var partLabel: UILabel!
    @IBOutlet var servicePrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setUpViews()
        setUp()
        
        fetchUser()
    }
    
    //MARK: - Create Confirm Object to Hold Part Data + Service Date Data being passed via the segues
    let confirm = Confirm()
    var part: Part!
    var serviceDate = Date()
    
    //MARK: - Once you have the Passed Data (Service Date + Part) you need to add the confirm model to the Database under the user for child node "confirmed"
    
    func setUp(){
       
        confirm.partData = part
        print(confirm.partData.name)
        confirm.serviceDateData = serviceDate
        print("Confirm Date \(confirm.serviceDateData)")
        partLabel.text = "\(confirm.partData.name)"
        servicePrice.text = confirm.partData.price
        serviceImage.image = confirm.partData.image
        
        
       
        
    }
    
    func setUpViews() {
        
        confirmButton.layer.cornerRadius = 30
        confirmViewBox.layer.cornerRadius = 30
        confirmComments.layer.cornerRadius = 20
        serviceImage.layer.cornerRadius = 30
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        serviceDateLabel.text = dateFormatterGet.string(from: serviceDate)
        
    }
    
    
    //MARK: -  When the Confirm Button is tapped, we want to save the Confirm Model to the firebase, creating it as a new node value
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        confirmServiceForUser()
    }
    
    
    
    //MARK: - Fetch User From Database
    func fetchUser(){
           var users = [User]()
           let uid = Auth.auth().currentUser?.uid
           
           Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
               
               if let dictionary = snapshot.value as? [String: AnyObject] {
                   
                   let user = User()
                                 
                   user.setValuesForKeys(dictionary)
                   users.append(user)
                   
               }
           }, withCancel: nil)
       }
    
    func confirmServiceForUser(){
            var users = [User]()
            let uid = Auth.auth().currentUser?.uid
            
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let user = User()
                                  
                    user.setValuesForKeys(dictionary)
                    users.append(user)
                    
                    
                        
                        
                   
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy-MM-dd"
                    let confirm = dateFormatterGet.string(from: self.serviceDate)
                    
                    let confirmService = self.confirm.partData.name
                    let confirmPrice = self.confirm.partData.price
                                                
                        print("NEW CONFIRM::: \(confirm)")
                        
                    let values = ["confirmDate": "\(confirm)", "confirmService" : "\(confirmService)", "confirmPrice" : "\(confirmPrice)"]
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        self.createCopyForUserHealth(uid: uid,values: values as [String : AnyObject])
                        
                    
                }
            }, withCancel: nil)
        }
    
    //MARK: - Create Values For User
           func createCopyForUserHealth(uid: String, values: [String: AnyObject]) {
               var ref: DatabaseReference!
                   
                   ref = Database.database().reference(fromURL: "https://boatell-v3.firebaseio.com/")
                   
                   let userRef = ref.child("users").child(uid)
                   
                   userRef.updateChildValues(values) { (error, refer) in
                       if let error = error {
                           print("ERROR CHILD values: \(error)")
                           return
                       }
                 }
           }
    

}
