//
//  ServiceDetailPopUpViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/18/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ServiceDetailPopUpViewController: UIViewController {
    
    @IBOutlet var serviceName: UILabel!
    @IBOutlet var servicePrice: UILabel!
    
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var serviceDetailsTextView: UITextView!
    
    
    var part: FirebaseServices!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }
    

    func updateViews(){
        
        self.serviceName.text = part.serviceName
        self.servicePrice.text = part.servicePrice
        self.serviceDetailsTextView.text = part.serviceDetails
        self.serviceImage.loadImageUsingCacheWithUrlString(urlString: part.serviceImage!)
        nextButton.layer.cornerRadius = 30
        serviceImage.layer.cornerRadius = 40
        
    }
   
    //Change to Add To Cart
    @IBAction func confirmButtonTapped(_ sender: Any) {
        animateNext()
        UserServicesViewController.cartArray.append(part)
        UserServicesViewController.cartInt += 1
        
        nextButton.setTitle("Added To Cart", for: .normal)
        nextButton.backgroundColor = .green
     //  self.performSegue(withIdentifier: "ViewCalendarSegue", sender: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - Set Up Animation
       func animateNext() {
           UIView.animate(withDuration: 0.2, animations: {               //45 degree rotation. USE RADIANS
               self.nextButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 0.1).concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
                   
               }) { (_) in //Is finished
                   
                   
                   UIView.animate(withDuration: 0.01, animations: {
                       self.nextButton.transform = .identity
                   })
                                   
               }
       }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ViewCalendarSegue" {
//                 guard let partSelectVC = segue.destination as? UserCalendarViewController else{return}
//
//          
//            let selectedPart = self.part
//                 partSelectVC.part = selectedPart
//
//             }
//    }
    

}
