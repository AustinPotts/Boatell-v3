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
    
    var part: Part!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }
    

    func updateViews(){
        
        self.serviceName.text = part.name
        self.servicePrice.text = part.price
        self.serviceImage.image = part.image
        nextButton.layer.cornerRadius = 30
        serviceImage.layer.cornerRadius = 40
        
    }
   
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
       self.performSegue(withIdentifier: "ViewCalendarSegue", sender: nil)
        
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
