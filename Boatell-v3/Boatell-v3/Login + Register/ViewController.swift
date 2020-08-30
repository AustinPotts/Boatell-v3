//
//  ViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 8/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    //MARK: - Interface Outlets
    @IBOutlet var textBoxView: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        textBoxView.layer.cornerRadius = 35
        loginButton.layer.cornerRadius = 30
    }
    
    //MARK: - Set Up User Log In
       func handleLogIn() {
            
            guard let email = username.text, let password = password.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    
                 //  self.showAlert() // Show Wrong Email or Password Alert
                    print("Error signing in: \(error)")
                    return
                }
                
                self.performSegue(withIdentifier: "LogInSegue", sender: self)
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

    
    @IBAction func loginButtonTapped(_ sender: Any) {
        handleLogIn()
        animateLogin()
    }
    

}

