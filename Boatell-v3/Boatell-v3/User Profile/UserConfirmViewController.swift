//
//  UserConfirmViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/1/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class UserConfirmViewController: UIViewController {
    
    //MARK: - Interface Outlets
    
    @IBOutlet var confirmViewBox: UIView!
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var confirmComments: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setUpViews()
    }
    
    func setUpViews() {
        
        confirmButton.layer.cornerRadius = 30
        confirmViewBox.layer.cornerRadius = 30
        confirmComments.layer.cornerRadius = 20
        serviceImage.layer.cornerRadius = 30
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
