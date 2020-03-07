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
    
    private let baseURL = URL(string: "https://webpt9-water-my-plants.herokuapp.com/api")!
    var plants: [Plant] = []
    var token: Token?
    var user: User?
    var plant: Plant?
    var loginController = LoginController.shared
    var signUp = SignUpController.shared
    func fetchAllPlants(completion: @escaping (Result<[Plant], NetworkError>) -> Void) {
        let requestURL = baseURL.appendingPathComponent("/\(loginController.token?.user_id)/plants")
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.badAuth))
            }
            
            if error != nil {
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let plants = try decoder.decode([Plant].self, from: data)
                completion(.success(plants))
            } catch {
                print("Error decoding plants: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func addPlant(id: Int?,
                  nickname: String,
                  species: String,
                  h2oFrequency: Int,
                  image: String?,
                  user_id: Int,
                  completion: @escaping (Result<Plant, NetworkError>) -> Void) {
        let requestURL = baseURL.appendingPathComponent("/\(loginController.token?.user_id)/plants")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        
        let newPlantRequest = PlantRequest(id: id,
                                           nickname: nickname,
                                           species: species,
                                           h2oFrequency: h2oFrequency,
                                           image: image ?? "",
                                           user_id: (loginController.token?.user_id)!)
        print(newPlantRequest)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(newPlantRequest)
            request.httpBody = jsonData
        } catch {
            print("Error encoding plant object: \(error.localizedDescription)")
            completion(.failure(.otherError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(.failure(.badAuth))
            }
            
            if error != nil {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let plant = try decoder.decode(Plant.self, from: data)
                self.plants.append(plant)
                completion(.success(plant))
            } catch {
                print("Error decoding plant adter creating: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func updatePlant(id: Int,
                     nickname: String,
                     species: String,
                     h2oFrequency: Int,
                     image: String,
                     completion: @escaping (Result<Plant, NetworkError>) -> Void) {
        guard let index = self.plants.firstIndex(where: { plant in plant.id == id }) else { return }
        
        var updatedPlant = self.plants[index]
        updatedPlant.nickname = nickname
        updatedPlant.species = species
        updatedPlant.h2oFrequency = h2oFrequency
        updatedPlant.image = image
        
        self.plants[index] = updatedPlant
        
        let requestURL = baseURL.appendingPathComponent("/\(loginController.token?.user_id)/plants/\(loginController.token?.id)")
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(updatedPlant)
            request.httpBody = jsonData
        } catch {
            print("Error encoding updateObject: \(error.localizedDescription)")
            completion(.failure(.otherError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.badAuth))
            }
            
            if error != nil {
                completion(.failure(.badData))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let plant = try decoder.decode(Plant.self, from: data)
                self.plants.append(plant)
                completion(.success(plant))
            } catch {
                print("Error decoding updated plant after updating: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func deletePlant(completion: @escaping (Result<Plant, NetworkError>) -> Void) {
        
        
        
        
        
        let requestURL = baseURL.appendingPathComponent("/\(loginController.token?.user_id)/plants/\(14)")
       
        
        var request = URLRequest(url: requestURL)
        print(requestURL)
        print()
        
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(.failure(.badAuth))
                print(response.statusCode)
            }
            
            if error != nil {
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let plant = try decoder.decode(Plant.self, from: data)
                completion(.success(plant))
                print("I tried to delete something")
            } catch {
                print("Error decoding plant after deleting: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    func updateUser(completion: @escaping (Result<User, NetworkError>) -> Void) {
        let requestURL = baseURL.appendingPathComponent("/auth/\(loginController.token?.id)")
        
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(.failure(.badAuth))
            }
            
            if error != nil {
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                print("error decoding user after updating: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
}
