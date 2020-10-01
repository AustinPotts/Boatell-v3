//
//  OwnerServiceDetailPopUpViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class OwnerServiceDetailPopUpViewController: UIViewController {

    @IBOutlet var serviceName: UILabel!
    @IBOutlet var servicePrice: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var editButton: UIButton!
    
        
        var part: Part!
       var service: FirebaseServices!

        override func viewDidLoad() {
            super.viewDidLoad()
            updateViews()
            nextButton.isHidden = true

        }
        

        func updateViews(){
            
            self.serviceName.text = part.name
            self.servicePrice.text = part.price
            self.serviceImage.image = part.image
            nextButton.layer.cornerRadius = 30
            serviceImage.layer.cornerRadius = 40
            
            editButton.layer.cornerRadius = editButton.frame.height / 2
            editButton.layer.masksToBounds = false
            editButton.clipsToBounds = true
            
        }
       
        
        @IBAction func confirmButtonTapped(_ sender: Any) {
           self.performSegue(withIdentifier: "ViewCalendarSegue", sender: nil)
            
        }
        
        
        
    @IBAction func editButtonTapped(_ sender: Any) {
        nextButton.isHidden = false
    }
    
        
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ViewCalendarSegue" {
                     guard let partSelectVC = segue.destination as? UserCalendarViewController else{return}

                let selectedPart = self.part
                     partSelectVC.part = selectedPart

                 }
        }
        

    }
