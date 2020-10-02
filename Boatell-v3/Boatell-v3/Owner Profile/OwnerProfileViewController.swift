//
//  OwnerProfileViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class OwnerProfileViewController: UIViewController {

     
        @IBOutlet var userImage: UIImageView!
        @IBOutlet var userLocation: UILabel!
        @IBOutlet var userName: UILabel!
        
        
        @IBOutlet var serviceHistoryButton: UIButton!
        @IBOutlet var yourBoatsButton: UIButton!
        @IBOutlet var scheduleServiceButton: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()

            updateViews()
            setUpViews()
        }
        
        //MARK: - User Property Observer
            var users: Users? {
                  didSet {
                      updateViews()
                  }
              }
        
        //MARK: - Update Views with Database Values
           func updateViews(){
             

            Database.database().reference().child("owner").child("owner").observeSingleEvent(of: .value, with: { (snapshot) in
                   
                   
                         
                         if let dictionary = snapshot.value as? [String: AnyObject] {
                           self.userName.text = dictionary["name"] as? String
                           let profileImageURL = dictionary["profileImageURL"] as? String
                           self.userImage.loadImageViewUsingCacheWithUrlString(urlString: profileImageURL!)
                           self.userImage.layer.cornerRadius = self.userImage.frame.height / 2
                           self.userImage.layer.masksToBounds = false
                           self.userImage.clipsToBounds = true
                         }
                         print(snapshot)
                     }, withCancel: nil)
           }
    
    //MARK: - Set Up Animation
             func animate() {
                 UIView.animate(withDuration: 0.2, animations: {               //45 degree rotation. USE RADIANS
                     self.serviceHistoryButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 0.1).concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
                         
                     }) { (_) in //Is finished
                         
                         
                         UIView.animate(withDuration: 0.01, animations: {
                             self.serviceHistoryButton.transform = .identity
                         })
                                         
                     }
             }
    
    func animate2() {
         UIView.animate(withDuration: 0.2, animations: {               //45 degree rotation. USE RADIANS
             self.yourBoatsButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 0.1).concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
                 
             }) { (_) in //Is finished
                 
                 
                 UIView.animate(withDuration: 0.01, animations: {
                     self.yourBoatsButton.transform = .identity
                 })
                                 
             }
     }
    
    @IBAction func appointmentHistoryTapped(_ sender: Any) {
        animate()
    }
    
    
    @IBAction func editServicesTapped(_ sender: Any) {
        animate2()
    }
    
        
        func setUpViews(){
            serviceHistoryButton.layer.cornerRadius = 30
            yourBoatsButton.layer.cornerRadius = 30
            scheduleServiceButton.layer.cornerRadius = 30
        }
        
        @IBAction func unwindToProfile( _ seg: UIStoryboardSegue) {
               
           }

     

    }
