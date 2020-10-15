//
//  UserServicesViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 8/30/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

struct CustomData {
    var title: String
    var image: UIImage
    var url: String
}

class UserServicesViewController: UIViewController {
    
    
    

    let partController = PartController()
    var services = [FirebaseServices]()


    
    fileprivate let collectionView: UICollectionView = {
                  let layout = UICollectionViewFlowLayout()
                 layout.scrollDirection = .vertical
                  let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
                  cv.translatesAutoresizingMaskIntoConstraints = false
                  cv.register(CustomCell2.self, forCellWithReuseIdentifier: "cell")
                  return cv
              }()
    
    
    //Fetch Services
    func fetchServices() {
         Database.database().reference().child("owner").child("owner").child("services").observe(.childAdded, with: { (snapshot) in
                 
                 if let dictionary = snapshot.value as? [String: AnyObject] {
                     let service = FirebaseServices()
                     
                     //App will crash if Class properties don't exactly match up with the Firebase Dictionary Keys
                     service.setValuesForKeys(dictionary)
                     self.services.append(service)
                    // print(user.name!, user.email!)
                     
                     
                         self.collectionView.reloadData()
                     
                     
                 }
                 
                 
     //            print(snapshot)
                 
             }, withCancel: nil)
         }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       fetchServices()
        view.addSubview(collectionView)
                   collectionView.backgroundColor = .clear
                   collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
                   collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
                   collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
                   collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0).isActive = true
           //        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.5).isActive = true
           //
                   collectionView.delegate = self
                   collectionView.dataSource = self //Methods wont run if these arent called
    }
    
    
    

   

}

extension UserServicesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.1, height: collectionView.frame.width/2)
       }
       
     
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
       }
        
      
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell2
            
                // Configure the cell
               // let part = partController.part[indexPath.item]
         cell.data = self.services[indexPath.row]
                return cell
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "ShowServiceDetailSegue" {
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first?.item,
            let partSelectVC = segue.destination as? ServiceDetailPopUpViewController else{return}
            
            let selectedPart = services[indexPath]
            partSelectVC.part = selectedPart
            
            }

     }
    
    //MARK: Pass Part Object Data Here 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowServiceDetailSegue", sender: indexPath)
    }
    
    @IBAction func unwindToServices( _ seg: UIStoryboardSegue) {
        
    }
    
}

class CustomCell: UICollectionViewCell {
    
    var data: FirebaseServices? {
        didSet{
            guard let data = data else {return}
          //  bg.image = data.serviceImage
            self.bg.loadImageViewUsingCacheWithUrlString(urlString: data.serviceImage!)
            labelViewText.text = data.serviceName
          //  priceLabel.text = data.servicePrice
            

        }
    }

    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Cut")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        
        return iv
    }()
    
    fileprivate let blackLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    fileprivate let labelViewText: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = UIColor.white
        label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
  
//    fileprivate let priceLabel: UILabel = {
//        let priceLabel = UILabel()
//        priceLabel.text = "$10.00"
//        priceLabel.font.withSize(7)
//        priceLabel.textColor = .white
//        priceLabel.translatesAutoresizingMaskIntoConstraints = false
//        return priceLabel
//    }()
    
    fileprivate let priceView: UIView = {
       let priceView = UIView()
        priceView.backgroundColor = .green
        priceView.layer.cornerRadius = 5
        priceView.alpha = 0.9
        priceView.translatesAutoresizingMaskIntoConstraints = false
        return priceView
    }()
    
    fileprivate let addToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.imageView?.image = .strokedCheckmark
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           contentView.addSubview(bg)
           bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
           bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
           bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
           bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
           
           bg.addSubview(blackLabelView)
           blackLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
           blackLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
           blackLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
           blackLabelView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
//        bg.addSubview(addToCartButton)
//        addToCartButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
//        addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
//        addToCartButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
//        addToCartButton.widthAnchor.constraint(equalToConstant: 10).isActive = true
           
        blackLabelView.addSubview(labelViewText)
        labelViewText.centerYAnchor.constraint(equalTo: blackLabelView.centerYAnchor).isActive = true
        labelViewText.centerXAnchor.constraint(equalTo: blackLabelView.centerXAnchor).isActive = true
        
      
    
        
        bg.addSubview(priceView)
        priceView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        priceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        priceView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        priceView.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        priceView.addSubview(addToCartButton)
        addToCartButton.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 5).isActive = true
        addToCartButton.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 5).isActive = true
        
      

        
        
        

       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
