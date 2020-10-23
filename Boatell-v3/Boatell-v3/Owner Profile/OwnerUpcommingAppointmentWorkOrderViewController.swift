//
//  OwnerUpcommingAppointmentWorkOrderViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class OwnerUpcommingAppointmentWorkOrderViewController: UIViewController {

    @IBOutlet var workOrderView: UIView!
    @IBOutlet var serviceName: UILabel!
    @IBOutlet var serviceDate: UILabel!
    @IBOutlet var servicePrice: UILabel!
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var clientCommentsTextView: UITextView!
    
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var serviceCompleteSegmentController: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       updateViews()

    }
    
    var confirmed: FirebaseConfirm? 
    
    
    
    func updateViews() {
        workOrderView.layer.cornerRadius = 30
        saveButton.layer.cornerRadius = 30
        self.serviceName.text = confirmed?.confirmService!
         self.serviceDate.text = "\(confirmed!.confirmDate!) at \(confirmed!.confirmTime!)"
        self.servicePrice.text = confirmed?.confirmPrice!
        self.userName.text = confirmed?.userName
        self.clientCommentsTextView.text = confirmed?.clientComments 
        
        if let confirmImageURL = confirmed?.confirmImage {

                         serviceImage.loadImageViewUsingCacheWithUrlString(urlString: confirmImageURL)
                  serviceImage.layer.cornerRadius = 70

                }
        
        
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any){
        // Update new values in database for confirmComplete node
        updateUserConfirmComplete()
    }
    
    //Segment Controller Action
    var confirmComplete = ""
    
    @IBAction func indexChanged(_ sender: Any) {
         switch serviceCompleteSegmentController.selectedSegmentIndex
         {
         case 0:
             confirmComplete = "Not Complete"
         case 1:
             confirmComplete = "Complete"
         default:
             break
         }
     }
    
    //MARK: - Update Confirm Complete Value
    func updateUserConfirmComplete(){
              var owners = [Owner]()
              let uid = Auth.auth().currentUser?.uid
              
        //MARK: - You need to get the Confirmed Child By Auto ID for refrence node
        Database.database().reference().child("owner").child("owner").child("confirmed").observeSingleEvent(of: .value, with: { (snapshot) in
                  
                print("Snap: \(snapshot)")
                  if let dictionary = snapshot.value as? [String: AnyObject] {
                   // self.confirmComplete = dictionary["confirmComplete"] as? String ?? ""
                      let owner = Owner()
                                    
                      owner.setValuesForKeys(dictionary)
                    owners.append(owner)
                      
                          
                    let values = ["confirmComplete": self.confirmComplete]
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    self.createCopyForUserValues(uid: uid,values: values as [String : AnyObject])
                    
                          }
              }, withCancel: nil)
          }
          

           //MARK: - Create Values For User
    func createCopyForUserValues(uid: String, values: [String: AnyObject]) {
        var ref: DatabaseReference!
        
        ref = Database.database().reference(fromURL: "https://boatell-v3.firebaseio.com/")
        
        let userRef = ref.child("users").child(uid).child("confirmed").childByAutoId()
        //   let childRef = ref.child("confirmed").childByAutoId()
        let ownerRef = ref.child("owner").child("owner").child("confirmed").childByAutoId()
        
        userRef.updateChildValues(values) { (error, refer) in
            if let error = error {
                print("ERROR CHILD values: \(error)")
                return
            }
        }
        ownerRef.updateChildValues(values) { (error, refer) in
            if let error = error {
                print("ERROR CHILD values: \(error)")
                return
            }
        }
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
