//
//  OwnerEditServicesViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

struct CustomData2 {
    var title: String
    var image: UIImage
    var url: String
}

class OwnerEditServicesViewController: UIViewController {
       

        let partController = PartController()
        
        //MARK: -  This Mock Data needs to be Data pulled from the Database of the specific Owners Services
        //MARK: - The Data pulled from the Owners available Services in the Database, will be passed into the Part object
        let data = [
            Part(name: "Fluxer Control", price: "$19.99", imageName: "Cut", partNumber: "Fluxer Control made of stainless steel, this part will help reduce rust on cords."),
            Part(name: "Floater Control", price: "$30.99", imageName: "Engine", partNumber: "A Floater Control not only helps your boat maintain boyance, but also speed handling"),
            Part(name: "Bellbop Hinge", price: "$23.50", imageName: "Gadget", partNumber: "This part will help keep the oil heated to flow more easily through the shaft."),
            Part(name: "Fluxer Control", price: "$19.99", imageName: "Cut", partNumber: "Fluxer Control made of stainless steel, this part will help reduce rust on cords."),
            Part(name: "Floater Control", price: "$30.99", imageName: "Lights", partNumber: "A Floater Control not only helps your boat maintain boyance, but also speed handling"),
            Part(name: "Bellbop Hinge", price: "$23.50", imageName: "Cut", partNumber: "This part will help keep the oil heated to flow more easily through the shaft."),
            Part(name: "Fluxer Control", price: "$19.99", imageName: "Cut", partNumber: "Fluxer Control made of stainless steel, this part will help reduce rust on cords."),
            Part(name: "Floater Control", price: "$30.99", imageName: "Engine", partNumber: "A Floater Control not only helps your boat maintain boyance, but also speed handling"),
            Part(name: "Bellbop Hinge", price: "$23.50", imageName: "Gadget", partNumber: "This part will help keep the oil heated to flow more easily through the shaft."),
            Part(name: "Fluxer Control", price: "$19.99", imageName: "Cut", partNumber: "Fluxer Control made of stainless steel, this part will help reduce rust on cords."),
            Part(name: "Floater Control", price: "$30.99", imageName: "Lights", partNumber: "A Floater Control not only helps your boat maintain boyance, but also speed handling"),
            Part(name: "Bellbop Hinge", price: "$23.50", imageName: "Cut", partNumber: "This part will help keep the oil heated to flow more easily through the shaft.")
                     
                         ]
        
        fileprivate let collectionView: UICollectionView = {
                      let layout = UICollectionViewFlowLayout()
                     layout.scrollDirection = .vertical
                      let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
                      cv.translatesAutoresizingMaskIntoConstraints = false
                      cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
                      return cv
                  }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            

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

    extension OwnerEditServicesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width/2.1, height: collectionView.frame.width/2)
           }
           
         
           func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return data.count
           }
            
          
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
                
                    // Configure the cell
                   // let part = partController.part[indexPath.item]
             cell.data = self.data[indexPath.row]
                    return cell
            }
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if segue.identifier == "ShowServiceDetailSegue" {
                guard let indexPath = collectionView.indexPathsForSelectedItems?.first?.item,
                let partSelectVC = segue.destination as? ServiceDetailPopUpViewController else{return}
                
                let selectedPart = data[indexPath]
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

    class CustomCell2: UICollectionViewCell {
        
        var data: Part? {
            didSet{
                guard let data = data else {return}
                bg.image = data.image
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
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(bg)
            bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }

