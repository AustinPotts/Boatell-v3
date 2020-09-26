//
//  UserServiceDetailViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/25/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class UserServiceDetailViewController: UIViewController {

    @IBOutlet var workOrderView: UIView!
    @IBOutlet var serviceName: UILabel!
    @IBOutlet var serviceDate: UILabel!
    @IBOutlet var servicePrice: UILabel!
    @IBOutlet var serviceImage: UIImageView!
    
   
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
           updateViews()

        }
        
        var confirmed: FirebaseConfirm?
        
        
        
        func updateViews() {
            workOrderView.layer.cornerRadius = 30
            self.serviceName.text = confirmed?.confirmService
            self.serviceDate.text = confirmed?.confirmDate
            self.servicePrice.text = confirmed?.confirmPrice
            
            if let confirmImageURL = confirmed?.confirmImage {

                             serviceImage.loadImageViewUsingCacheWithUrlString(urlString: confirmImageURL)
                      serviceImage.layer.cornerRadius = 70

                    }
            
            
            
        }
        
        
        @IBAction func backButtonTapped(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
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
