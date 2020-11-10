//
//  ViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 8/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Interface Outlets
    @IBOutlet var textBoxView: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var userSegmentController: UISegmentedControl!
    
    
    let customAlert = MyAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        username.delegate = self
        password.delegate = self
    }
    
    func setUpViews() {
        textBoxView.layer.cornerRadius = 30
        loginButton.layer.cornerRadius = 30
    }
    
    //MARK: - Set Up User Log In
       func handleLogIn() {
        
      
            
            guard let email = username.text, let password = password.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    
                 //  self.showAlert() // Show Wrong Email or Password Alert
                    print("Error signing in: \(error)")
                    self.customAlert.showAlertWithTitle("Your email or password was incorrect.", "Please try again", self)
                    return
                }
                
                
                
                self.performSegue(withIdentifier: "LogInSegue", sender: self)
            }
         
        
            
        }
    
    
    //MARK: - Set Up Owner Log In
    func handleOwnerLogin() {
        
     
         
         guard let email = username.text, let password = password.text else { return }
         
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
             if let error = error {
                 
              //  self.showAlert() // Show Wrong Email or Password Alert
                 print("Error signing Owner in: \(error)")
                 return
             }
             
             self.performSegue(withIdentifier: "OwnerLoginSegue", sender: self)
         }
      
         
     }
    
    //MARK: - Set Up Login Animation
      func animateLogin() {
          UIView.animate(withDuration: 0.2, animations: {               //45 degree rotation. USE RADIANS
              self.loginButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 0.1).concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
                  
              }) { (_) in //Is finished
                  
                  
                  UIView.animate(withDuration: 0.01, animations: {
                      self.loginButton.transform = .identity
                  })
                                  
              }
      }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
         
     }

    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if userBool == true {
            handleLogIn()
            animateLogin()
        } else if ownerBool == true {
            handleOwnerLogin()
            animateLogin()
        }
       
    }
    
    var userBool: Bool = true
    var ownerBool: Bool = false
    
    @IBAction func indexChanged(_ sender: Any) {
        switch userSegmentController.selectedSegmentIndex
        {
        case 0:
            userBool = true
            ownerBool = false
        case 1:
            ownerBool = true
            userBool = false
        default:
            break
        }
    }
        
    
    //TEXT FIELD DELEGATION
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        username.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }

}



