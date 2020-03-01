//
//  SignUpController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class SignUpController {
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://webpt9-water-my-plants.herokuapp.com/api")!
    
    //Create function for signUp
    func signUp(with signupData: SignUpRequest, completion: @escaping CompletionHandler) {
        let signUpURL = baseURL.appendingPathComponent("/auth/register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(signupData)
            request.httpBody = jsonData
        } catch {
            print("error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                print(response.statusCode)
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let _ = data else {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
