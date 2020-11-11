//
//  OwnerAddNewServiceViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 10/1/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class OwnerAddNewServiceViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var serviceNameTextField: UITextField!
    @IBOutlet var servicePriceTextField: UITextField!
    @IBOutlet var serviceDetailsTextView: UITextView!
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        serviceNameTextField.delegate = self
        servicePriceTextField.delegate = self
        serviceDetailsTextView.delegate = self
    }
    
     let customALert = MyAlert()
    
    
    func updateViews() {
        mainView.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 30
        serviceDetailsTextView.layer.cornerRadius = 20
    }
    
    //MARK: - Set Up Login Animation
         func animateSave() {
             UIView.animate(withDuration: 0.2, animations: {               //45 degree rotation. USE RADIANS
                 self.saveButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 0.1).concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
                     
                 }) { (_) in //Is finished
                     
                     
                     UIView.animate(withDuration: 0.01, animations: {
                         self.saveButton.transform = .identity
                     })
                                     
                 }
         }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        serviceNameTextField.resignFirstResponder()
        servicePriceTextField.resignFirstResponder()
        serviceDetailsTextView.resignFirstResponder()
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
            serviceDetailsTextView.resignFirstResponder()

               return false
           }
           return true
       }

    
    
    // Once Save Button is tapped, the function "addServiceToOwner" should be called
    // addServiceToOwner will add the input values (Name,Price,Details,Image) to a new Node under the owner
    
     
    func addServiceToOwner(){
        
            
        
        let imageName = NSUUID().uuidString
                                                 
                     let storageRef = Storage.storage().reference().child("\(imageName).png")
                     
                     if let uploadData = self.serviceImage.image?.pngData() {
                         
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
                                 
                                 if let confirmImage = url?.absoluteString {
                                     
                                    let values = ["serviceName": self.serviceNameTextField.text!, "servicePrice" : self.servicePriceTextField.text!, "serviceDetails" : self.serviceDetailsTextView.text!, "serviceImage" : confirmImage]
                                     
                                     
                                     guard let uid = Auth.auth().currentUser?.uid else { return }
                                     
                                     self.createCopyForOwnerServices(uid: uid,values: values as [String : AnyObject])
                                     
                                 }
                                 
                             }
                             
                         }
                         
                     }
    
    }
    
    
    //MARK: - Create Values For User
      func createCopyForOwnerServices(uid: String, values: [String: AnyObject]) {
          var ref: DatabaseReference!
          
          ref = Database.database().reference(fromURL: "https://boatell-v3.firebaseio.com/")
          

        let ownerRef = ref.child("owner").child("owner").child("services").childByAutoId()
          
       
          ownerRef.updateChildValues(values) { (error, refer) in
              if let error = error {
                  print("ERROR CHILD values: \(error)")
                  return
              }
          }
      }

    
    
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
                          picker.allowsEditing = false
                          picker.delegate = self
                          picker.sourceType = .photoLibrary
                          present(picker, animated: true)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        addServiceToOwner()
        animateSave()
        customALert.showAlertWithTitle("This service had been added", "Your clients will also see this new added service.", self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}

extension OwnerAddNewServiceViewController {
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
            serviceImage.image = newImage
       
    
             
        }
    
    
    
    
}

//extension Data {
//
//    init<T>(from value: T) {
//        self = Swift.withUnsafeBytes(of: value) { Data($0) }
//    }
//
//    func to<T>(type: T.Type) -> T? where T: ExpressibleByIntegerLiteral {
//        var value: T = 0
//        guard count >= MemoryLayout.size(ofValue: value) else { return nil }
//        _ = Swift.withUnsafeMutableBytes(of: &value, { copyBytes(to: $0)} )
//        return value
//    }
//}
