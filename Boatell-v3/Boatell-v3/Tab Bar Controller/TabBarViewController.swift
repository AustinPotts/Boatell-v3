//
//  TabBarViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 11/11/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let tabBarItem = (self.tabBar.items?.last as? UITabBarItem) {
//            tabBarItem.badgeValue = "●"              //seting color of bage optional by default red
//              tabBarItem.badgeColor = UIColor.red //
//              //setting atribute , optional
//            tabBarItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
//        }


        //Step 1: Add Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveMessageData, object: nil)

    }
    
    //MARK:- Actions for Notification Observer
    @objc func onDidReceiveData(_ notification:Notification) {
       
        let tabBar = TabBarViewController()
        if let tabBarItem = (self.tabBar.items?.last as? UITabBarItem) {
            tabBarItem.badgeValue = "●"              //seting color of bage optional by default red
              tabBarItem.badgeColor = UIColor.red //
              //setting atribute , optional
            tabBarItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
        }
        
    }
    

}
