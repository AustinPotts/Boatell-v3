//
//  ViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 8/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

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

    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    

}

