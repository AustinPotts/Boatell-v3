//
//  OwnerServiceHistoryViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//


import UIKit
import Firebase

class OwnerServiceHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    var owner = [Owner]()
    var confirmed = [FirebaseConfirm]()
    
    
    
    @IBOutlet var serviceHistoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUsers()
        serviceHistoryTableView.delegate = self
        serviceHistoryTableView.dataSource = self
        serviceHistoryTableView.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        confirmed.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceTableViewCell else {
                print("NO CELL")
                return UITableViewCell()}
        
        cell.confirmed = confirmed[indexPath.row]
        cell.backgroundColor = UIColor.clear
        
        return cell
        
     }
    
    //MARK: - Fetch User From Database
          func fetchUsers() {
            
            
            
            Database.database().reference().child("owner").child("owner").child("confirmed").observe(.childAdded, with: { (snapshot) in
                  
                  if let dictionary = snapshot.value as? [String: AnyObject] {
                      let owner = Owner()
                      let confirm = FirebaseConfirm()
                      
                      //App will crash if Class properties don't exactly match up with the Firebase Dictionary Keys
                      confirm.setValuesForKeys(dictionary)
                      
                    self.confirmed.append(confirm)
                      self.owner.append(owner)
                          
                      DispatchQueue.main.async {
                           self.serviceHistoryTableView.reloadData()
                      }
                  }
                  print(snapshot)
              }, withCancel: nil)
          }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CellSegue" {
            guard let indexPath = serviceHistoryTableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? OwnerAppointmentHistoryDetailViewController else {return}
            
            let confirm = confirmed[indexPath.row]
            detailVC.confirmed = confirm
            
            
        }
                   
    }
    

}
