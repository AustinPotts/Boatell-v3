//
//  RegisterViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 8/28/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFunctions
import Stripe

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    //MARK: - Interface Outlets
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var textBoxView: UIView!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var userSegmentController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        username.delegate = self
        email.delegate = self
        password.delegate = self
    }
    
    //Text Field Delegation
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        username.resignFirstResponder()
        password.resignFirstResponder()
        email.resignFirstResponder()
        return true
    }
    
    //MARK: Verification Email
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                // Notify the user that the mail has sent or couldn't because of an error.
            })
        }
        else {
            // Either the user is not available, or the user is already verified.
        }
    }
    
    let customAlert = MyAlert()
    
    //MARK: - Set Up Views
    func setUpViews() {
        
        textBoxView.layer.cornerRadius = 30
        registerButton.layer.cornerRadius = 30
    }
    
    
    var customerID: String = ""
    
    // Create function to handle register logic for USer
    func handleRegister() {
            
            guard let email = email.text, let password = password.text, let name = username.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print("Error: \(error)")
                    
                    return
                }
                
                //MARK: Verification Email Test
                self.sendVerificationMail()
                self.firebaseStripe()
               
                
                guard let uid = user?.user.uid else { return }
                
                let imageName = NSUUID().uuidString
                
                let storageRef = Storage.storage().reference().child("\(imageName).png")
                
                if let uploadData = self.userImage.image?.pngData() {
                    
                    storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading image data: \(error)")
                            return
                        }
                    
                        storageRef.downloadURL { (url, error) in
                            if let error = error {
                                print("Error downloading URL: \(error)")
                                return
                            }
                            
                             if let profileImageUrl = url?.absoluteString {
                                
                                let values = ["name": name, "email": email, "profileImageURL": profileImageUrl, "customer_id" : self.customerID]
                                print("Values Cus ID \(self.customerID)")
                                
                                self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                              
                            }
                            
                        }
                    
                    }
                    
                }
                
            }
        //MARK: When a new user is created, register them with Stripe
        
       // registerUserWithStripe()
        
        
        }
    
    //MARK: - Firebase Functions
    func firebaseStripe(){
        
        var functions = Functions.functions(region: "us-central1")
 
        guard let email = email.text, let name = username.text else { return }

        //MARK: - ERROR JSON text did not start with array or object and option to allow fragments not set.?
        functions.httpsCallable("createStripeCustomer").call(["name" : name, "email" : email]) { (response, error) in
                if let error = error {
                    print(error)
                }
                if let response = (response?.data as? [String: Any]) {
                    let customer_id = response["customer_id"] as! String?
                    print("Customer Stripe ID: \(customer_id)")
                    
                    
                    //MARK: - Where do I access the publishable key?
                    //print(publishable_key)
                    //Stripe.setDefaultPublishableKey(publishable_key!)
                    
                        // let user = Users()
                    self.customerID = customer_id!
                    
                    let defaults = UserDefaults.standard
                   // currentProfile = profile
                    
                    do {
                        //try self.db.collection("Profile").document("emailAdd").setData(from: user)
                        DispatchQueue.main.async {
                           // self.switchToWelcomePage()
                        }
                    } catch let error {
                        print (error)
                    }
                }
            }
        }
    
    
    


    
    
    
        private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
            // Successfully Registered Value
                 var ref: DatabaseReference!
                 
                 ref = Database.database().reference(fromURL: "https://boatell-v3.firebaseio.com/")
                 
                 let userRef = ref.child("users").child(uid)
                 
    //             let values = ["name": name, "email": email, "profileImageURL": metadata.downloadURL()]
                 
                 userRef.updateChildValues(values) { (error, refer) in
                     if let error = error {
                         print("error child values: \(error)")
                         self.customAlert.showAlertWithTitle("Error Creating Account.", "\(error)", self)
                         return
                     }
                     DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        //Once User is registered, register them in Stripe
                                        
                                        self.performSegue(withIdentifier: "RegisterSegue", sender: self)
                        
                                    }
                       self.customAlert.showAlertWithTitle("Your profile has been created!", "An Email confirmation will be sent to you.", self)
                     print("Saved user successfully into firebase db")
                 }
        }
    
    //MARK: - GOAL - Once the owner choice is selected upon register, the Owners data should be saved on its own seperate node
    
    // create Handle Owner Register
    
    func handleOwnerRegister() {
               
               guard let email = email.text, let password = password.text, let name = username.text else { return }
               
               Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                   if let error = error {
                       print("Error: \(error)")
                       
                       return
                   }
                  
                   
                   guard let uid = user?.user.uid else { return }
                   
                   let imageName = NSUUID().uuidString
                   
                   let storageRef = Storage.storage().reference().child("\(imageName).png")
                   
                   if let uploadData = self.userImage.image?.pngData() {
                       
                       storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                           if let error = error {
                               print("Error uploading image data: \(error)")
                               return
                           }
                       
                           storageRef.downloadURL { (url, error) in
                               if let error = error {
                                   print("Error downloading URL: \(error)")
                                   return
                               }
                               
                                if let profileImageUrl = url?.absoluteString {
                                   
                                   let values = ["name": name, "email": email, "profileImageURL": profileImageUrl]
                                   
                                   self.registerOwnerIntoDatabaseWithUID(values: values as [String : AnyObject])
                               }
                               
                           }
                       
                       }
                       
                   }
                   
               }
           }
    
       private func registerOwnerIntoDatabaseWithUID(values: [String: AnyObject]) {
            // Successfully Registered Value
                  // var ref: DatabaseReference!
                                 
                 let ref = Database.database().reference().child("owner")
                 
                 let userRef = ref.child("owner")
                 
    //             let values = ["name": name, "email": email, "profileImageURL": metadata.downloadURL()]
                 
                 userRef.updateChildValues(values) { (error, refer) in
                     if let error = error {
                         print("error onwer values: \(error)")
                         self.customAlert.showAlertWithTitle("Error Creating Account.", "\(error)", self)
                         return
                     }
                     DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        self.performSegue(withIdentifier: "OwnerRegisterSegue", sender: self)
                                    }
                     print("Saved owner successfully into firebase db")
                 }
        }
    
    //MARK: - Set Up Register Animation
     func animateRegister() {
            UIView.animate(withDuration: 0.2, animations: {               //45 degree rotation. USE RADIANS
             self.registerButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 0.1).concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
                    
                }) { (_) in //Is finished
                    
                    UIView.animate(withDuration: 0.01, animations: {
                        self.registerButton.transform = .identity
                    })
                    
                }
        }
    
    //MARK: - Interface Actions
    @IBAction func registerTapped(_ sender: Any) {
        
        //Do logic in here for the Segment Controller i.e if set then etc
        
        if userBool == true {
            handleRegister()
            animateRegister()
        } else if ownerBool == true {
            handleOwnerRegister()
            animateRegister()
        }
     
    }
    
    var userBool: Bool = false
    var ownerBool: Bool = false
        
    @IBAction func cameraButtonTapped(_ sender: Any) {
           let picker = UIImagePickerController()
                     picker.allowsEditing = false
                     picker.delegate = self
                     picker.sourceType = .photoLibrary
                     present(picker, animated: true)
       }
       
       
       @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
           view.endEditing(true)
       }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch userSegmentController.selectedSegmentIndex
        {
        case 0:
            userBool = true
        case 1:
            ownerBool = true
        default:
            break
        }
    }
    

    

}

extension RegisterViewController {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 227, height: 227), true, 2.0)
            image.draw(in: CGRect(x: 0, y: 0, width: 414, height: 326))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
            var pixelBuffer : CVPixelBuffer?
            let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
            guard (status == kCVReturnSuccess) else {
                return
            }
            
            CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
            
            context?.translateBy(x: 0, y: newImage.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            
            UIGraphicsPushContext(context!)
            newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            userImage.image = newImage
       
    
             
        }
    
    
    
    
}

extension Data {

    init<T>(from value: T) {
        self = Swift.withUnsafeBytes(of: value) { Data($0) }
    }

    func to<T>(type: T.Type) -> T? where T: ExpressibleByIntegerLiteral {
        var value: T = 0
        guard count >= MemoryLayout.size(ofValue: value) else { return nil }
        _ = Swift.withUnsafeMutableBytes(of: &value, { copyBytes(to: $0)} )
        return value
    }
}
