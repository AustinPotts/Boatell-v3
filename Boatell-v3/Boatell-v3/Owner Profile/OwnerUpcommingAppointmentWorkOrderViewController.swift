//
//  OwnerUpcommingAppointmentWorkOrderViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class OwnerUpcommingAppointmentWorkOrderViewController: UIViewController {

    @IBOutlet var workOrderView: UIView!
    @IBOutlet var serviceName: UILabel!
    @IBOutlet var serviceDate: UILabel!
    @IBOutlet var servicePrice: UILabel!
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var serviceCompleteSegmentController: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()

    }
    
    
    func updateViews() {
        workOrderView.layer.cornerRadius = 30
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
