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
    @IBOutlet var serviceDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setUpViews()
        setUp()
    }
    
    //MARK: - Create Confirm Object to Hold Part Data + Service Date Data being passed via the segues
    let confirm = Confirm()
    var part = Part?.self
    var serviceDate = Date()
    
    //MARK: - Once you have the Passed Data (Service Date + Part) you need to add the confirm model to the Database under the user for child node "confirmed"
    
    func setUp(){
       
        confirm.serviceDateData = serviceDate
        print("Confirm Date \(confirm.serviceDateData)")
        
    }
    
    func setUpViews() {
        
        confirmButton.layer.cornerRadius = 30
        confirmViewBox.layer.cornerRadius = 30
        confirmComments.layer.cornerRadius = 20
        serviceImage.layer.cornerRadius = 30
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        serviceDateLabel.text = dateFormatterGet.string(from: serviceDate)
        
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
