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
    
    @IBOutlet var serviceDetailsTextView: UITextView!
    
        var part: FirebaseServices!

        override func viewDidLoad() {
            super.viewDidLoad()
            updateViews()
            nextButton.isHidden = true

        }
    
    
        

        func updateViews(){
            
            self.serviceName.text = part.serviceName
            self.servicePrice.text = part.servicePrice
            self.serviceDetailsTextView.text = part.serviceDetails
            self.serviceImage.loadImageUsingCacheWithUrlString(urlString: part.serviceImage!)
            
            serviceDetailsTextView.layer.cornerRadius = 5
            nextButton.layer.cornerRadius = 30
            serviceImage.layer.cornerRadius = 40
            
            editButton.layer.cornerRadius = editButton.frame.height / 2
            editButton.layer.masksToBounds = false
            editButton.clipsToBounds = true
            
        }
    
    //MARK: - Set Up Login Animation
         func animateEdit() {
             UIView.animate(withDuration: 0.2, animations: {               //45 degree rotation. USE RADIANS
                 self.editButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 0.1).concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
                     
                 }) { (_) in //Is finished
                     
                     
                     UIView.animate(withDuration: 0.01, animations: {
                         self.editButton.transform = .identity
                     })
                                     
                 }
         }
       
        
        @IBAction func confirmButtonTapped(_ sender: Any) {
           self.performSegue(withIdentifier: "ViewCalendarSegue", sender: nil)
            
        }
        
        
        
    @IBAction func editButtonTapped(_ sender: Any) {
        nextButton.isHidden = false
        animateEdit()
    }
    
        
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "ViewCalendarSegue" {
//                     guard let partSelectVC = segue.destination as? UserCalendarViewController else{return}
//
//                let selectedPart = self.part
//                     partSelectVC.part = selectedPart
//
//                 }
//        }
        

    }
