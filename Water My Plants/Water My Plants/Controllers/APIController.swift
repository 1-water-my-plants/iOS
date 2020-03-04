//
//  APIController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class APIController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https:webpt9-water-my-plants.herokuapp.com/api")!
    var plants: [Plant] = []
    var loginController = LoginController.shared
    
    func fetchAllPlants(completion: @escaping (Result<[Plant], NetworkError>) -> Void) {
        let requestURL = baseURL.appendingPathComponent("/plants")
        //in progress
    }
    
    
}
