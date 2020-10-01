//
//  OwnerAddNewServiceViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 10/1/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class OwnerAddNewServiceViewController: UIViewController {
    
    @IBOutlet var serviceNameTextField: UITextField!
    @IBOutlet var servicePriceTextField: UITextField!
    @IBOutlet var serviceDetailsTextView: UITextView!
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    
    
    func updateViews() {
        mainView.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 30
        serviceDetailsTextView.layer.cornerRadius = 20
    }


    
    @IBAction func cameraButtonTapped(_ sender: Any) {
    }
    

}
