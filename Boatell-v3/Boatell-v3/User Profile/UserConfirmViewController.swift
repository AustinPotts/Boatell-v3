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
    let customALert = MyAlert()
    let ownerConfirmed = [Owner().confirmed]

    
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
        // Present Custom Alert
        
        customALert.showAlertWithTitle("Service Confirmed", "An Email has been sent to you.", self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.performSegue(withIdentifier: "unwind", sender: nil)
        }
        
    }
    
    @objc func dismissAlert(){
        customALert.dismissAlert()
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
                   
                   let userRef = ref.child("users").child(uid).child("confirmed").childByAutoId()
                //   let childRef = ref.child("confirmed").childByAutoId()
            let ownerRef = ref.child("owner").child("owner").child("confirmed").childByAutoId()
                   
                   userRef.updateChildValues(values) { (error, refer) in
                       if let error = error {
                           print("ERROR CHILD values: \(error)")
                           return
                       }
                 }
                 ownerRef.updateChildValues(values) { (error, refer) in
                                      if let error = error {
                                          print("ERROR CHILD values: \(error)")
                                          return
                                      }
                                }
           }
    
     
}


// Create Custom Alert Object

class MyAlert {
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView: UIView = {
        let backGroundView = UIView()
        backGroundView.backgroundColor = .black
        backGroundView.alpha = 0
        return backGroundView
    }()
    
    private let alertView: UIView = {
       let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.cornerRadius = 12
        alert.layer.masksToBounds = true
        return alert
    }()
    
    private var myTargetView: UIView?
    
     func showAlertWithTitle(_ title: String, _ message: String, _ onView: UIViewController){
        guard  let targetView = onView.view else {return}
        myTargetView = targetView
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width - 80, height: 250)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.frame.size.width, height: 80))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 80, width: alertView.frame.size.width, height: 170))
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        alertView.addSubview(messageLabel)
        
        let button = UIButton(frame: CGRect(x: 0, y: alertView.frame.size.height - 50, width: alertView.frame.size.width, height: 50))
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(button)
        
        UIView.animate(withDuration: 0.25, animations:  {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations:  {
                    self.alertView.center = targetView.center
                       })
            }
        })
        
    }
    
    @objc func dismissAlert(){
        
        guard let targetView = myTargetView else {return}
       
        
        UIView.animate(withDuration: 0.25, animations:  {
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.size.height, width: targetView.frame.size.width - 80, height: 200)

             }, completion: { done in
                 if done {
                     UIView.animate(withDuration: 0.25, animations:  {
                        self.backgroundView.alpha = 0
                     }, completion: { done in
                        if done {
                            self.alertView.removeFromSuperview()
                            self.backgroundView.removeFromSuperview()
                        }
                     })
                 }
             })
    }
    
}
