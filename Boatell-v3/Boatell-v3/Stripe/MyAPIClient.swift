//
//  BackendAPIAdapter.swift
//  Basic Integration
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions
import Firebase

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    enum APIError: Error {
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .unknown:
                return "Unknown error"
            }
        }
    }

    static let sharedClient = MyAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func createPaymentIntent(products: [Product], shippingMethod: PKShippingMethod?, country: String? = nil, completion: @escaping ((Result<String, Error>) -> Void)) {
        let url = self.baseURL.appendingPathComponent("create_payment_intent")
        var params: [String: Any] = [
            "metadata": [
                // example-mobile-backend allows passing metadata through to Stripe
                "payment_request_id": "B3E611D1-5FA1-4410-9CEC-00958A5126CB",
            ],
        ]
        params["products"] = products.map({ (p) -> String in
            return p.emoji
        })
        if let shippingMethod = shippingMethod {
            params["shipping"] = shippingMethod.identifier
        }
        params["country"] = country
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??),
                let secret = json?["secret"] as? String else {
                    completion(.failure(error ?? APIError.unknown))
                    return
            }
            completion(.success(secret))
        })
        task.resume()
    }

//    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
//        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
//
//        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
//
//        urlComponents.queryItems = [URLQueryItem(name: "api_version", value: apiVersion)]
//       // urlComponents.queryItems = [URLQueryItem(name: "customer_id", value: "cus_I6GoawcDOzuJM1")]
//
//        var request = URLRequest(url: urlComponents.url!)
//        request.httpMethod = "POST"
//
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//            guard let response = response as? HTTPURLResponse,
//                response.statusCode == 200,
//                let data = data,
//                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
//                completion(nil, error)
//                return
//            }
//            completion(json, nil)
//        })
//        task.resume()
//    }
    
    var users = [Users]()
    
    
    //MARK: - Fetch User From Database
          func fetchUsers() {
            let uid = Auth.auth().currentUser?.uid
            
            
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with:  { (snapshot) in
                  
                  if let dictionary = snapshot.value as? [String: AnyObject] {
                      let user = Users()
                     
                      
                      //App will crash if Class properties don't exactly match up with the Firebase Dictionary Keys
                      user.setValuesForKeys(dictionary)
                      
                   
                      self.users.append(user)
                      
                  }
                
                  print("Stripe Fetch Snap: \(snapshot)")
                
              }, withCancel: nil)
            print("STRIPE USERS COUNT \(self.users.count)")
          }

    
    //MARK: Currently this is the only Cloud Function not working properly, for some reason the User object is nil & therefore can't access the user.customer_id for Stripe
        func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
            var functions = Functions.functions(region: "us-central1")

            fetchUsers()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                print("USER COUNT STRIPE 1: \(self.users.count)")

            
                for user in self.users {
                    print("USER Stripe: \(user.customer_id)")
                
                functions.httpsCallable("getStripeEphemeralKeys").call(["api_version" : apiVersion, "customer_id" : user.customer_id]) { (response, error) in
                    if let error = error {
                        print("Here is the Key Error: \(error)")
                        completion(nil, error)
                    }
                    if let response = (response?.data as? [String: Any]) {
                        completion(response, nil)
                        print("MyStripeAPIClient response \(response)")
                    }
                }
            }
            
            
                print("USER COUNT STRIPE 2: \(self.users.count)")
            }
        }
    }


