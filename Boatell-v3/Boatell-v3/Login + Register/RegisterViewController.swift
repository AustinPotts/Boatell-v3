//
//  RegisterViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 8/28/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK: - Interface Outlets
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var textBoxView: UIView!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
     
    }
    
    //MARK: - Set Up Views
    func setUpViews() {
        
        textBoxView.layer.cornerRadius = 35
        registerButton.layer.cornerRadius = 30
    }
    
    // Create function to handle register logic for USer
     func handleRegister() {
            
            // Make sure you have the credentials needed to create a new User
            guard let email = email.text, let password = password.text, let name = username.text else { return }
            
            // Database.auth().createUser() using the unwrapped user credentials
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
                                let values = ["name": name, "email": email, "profileImageURL": profileImageUrl ]
                                
                                self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                            }
                            
                        }
                       // print(metadata)
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
                         return
                     }
                     
                     print("Saved user successfully into firebase db")
                 }
        }
    
    //MARK: - Interface Actions
    @IBAction func registerTapped(_ sender: Any) {
        handleRegister()
    }
        
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
