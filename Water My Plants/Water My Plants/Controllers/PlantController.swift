//
//  PlantController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://plants-e2f55.firebaseio.com/")!

class PlantController {
    let context = CoreDataStack.shared.container.newBackgroundContext()
    
    typealias CompletionHandler = (Error?) -> Void
    
    // fetch plants from controller
    init() {
        fetchPlantsFromServer()
    }
    
    func fetchPlantsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json") // can append json instead of using firebase SDK
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            guard error == nil else {
                print("Error fetching tasks: \(error!)")
                DispatchQueue.main.async {
                completion(error)
                }
                return
            }
            guard let data = data else {
                print("No Data Returned by data Task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            do {
                let plantRepresentations = Array(try JSONDecoder().decode([String: PlantRepresentation].self, from: data).values)
                // update plants
                try self.updatePlants(plants: plantRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
                print("Error decoding task representation: \(error)")
            }
        }.resume()
    }
    
     // send plant to server from local changes
    
    func sendPlantToServer(plant: Plant1, completion: @escaping CompletionHandler = {_ in }) {
        let id = plant.id ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(plant)
            
        } catch {
            print("Error encoding task \(plant): \(error)")
            completion(error)
            return
        }
        //send new plant entry to api
        URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                print("Error PUTing taks to server: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    //delete plant
    
    func deletePlantFromServer(_ plant: Plant1, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = plant.id else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                print("Error deleting task: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    
    // update Plants
    func updatePlants(plants: [PlantRepresentation]) throws {
        let plantsWithID = plants.filter { $0.id != nil }
        let identifierToFetch = plantsWithID.compactMap { $0.id }
        let representationsById = Dictionary(uniqueKeysWithValues: zip(identifierToFetch, plants))
        var plantsToCreate = representationsById
        
        let fetchRequest: NSFetchRequest<Plant1> = Plant1.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifierToFetch) // NSPredicate is how you filter in CoreData
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        func sync(plants: [PlantRepresentation], completion: @escaping (Error?) -> Void = { _ in}) {
            
            NSLog("Sync started")
            
            let identifiersToFetch = plants.compactMap { $0.id }
            let repsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, plants))
            var plantsToCreate = repsByID
            
            let fetchRequest: NSFetchRequest<Plant1> = Plant1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier in %@", identifiersToFetch)
            
            let context = CoreDataStack.shared.container.newBackgroundContext()
            self.context.perform {
                do {
                    let existingPlants = try context.fetch(fetchRequest)
                    
                    for plant in existingPlants {
                        guard let id = plant.id,
                            let representation = repsByID[id] else {
                                continue }
                        try self.updatePlants(plants: plants)
                        
                        plantsToCreate.removeValue(forKey: id)
                    }
                    
                    for representation in plantsToCreate.values {
                        _ = Plant1(plantRepresentation: representation, context: context)
                    }
                    completion(nil)
                    NSLog("Sync finished")
                } catch {
                    return
                }
            }
            try? context.save()

            
        
            }
        }
    }

private func update(plant: Plant1, with representation: PlantRepresentation) {
    plant.nickname = representation.nickname
    plant.species = representation.species
    plant.h2oFrequencyPerWeek = representation.h2oFrequencyPerWeek
 
}
