//
//  PaymentsViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 10/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions



class PaymentsViewController: UIViewController, STPPaymentContextDelegate {
    var paymentContext: STPPaymentContext
    
    override func viewDidLoad() {
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        self.paymentContext = STPPaymentContext(customerContext: customerContext)
        self.paymentContext.delegate = self
        self.paymentContext.hostViewController = self
        self.paymentContext.paymentAmount = 100
        
        self.paymentContext.pushPaymentOptionsViewController()
    }
    
    init() {
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        self.paymentContext = STPPaymentContext(customerContext: customerContext)
        super.init(nibName: nil, bundle: nil)
        self.paymentContext.delegate = self
        self.paymentContext.hostViewController = self
        self.paymentContext.paymentAmount = 100
        
        self.paymentContext.pushPaymentOptionsViewController()
    }
    
    required init?(coder: NSCoder) {
        self.paymentContext = STPPaymentContext()
        super.init(coder: coder)
    }
    
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    
    
    
}
