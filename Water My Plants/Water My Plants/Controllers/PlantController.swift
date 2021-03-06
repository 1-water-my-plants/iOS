//
//  PlantController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://plants2-991ad.firebaseio.com/")!

class PlantController {
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
                try self.updatePlants(with: plantRepresentations)
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
        let uuid = plant.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = plant.plantRepresentation else { completion(NSError())
            return }
            representation.identifier = uuid.uuidString
            plant.identifier = uuid
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
            request.httpBody = try JSONEncoder().encode(representation)
            
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
        guard let uuid = plant.identifier else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
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
    func updatePlants(with representations: [PlantRepresentation]) throws {
        let plantsWithID = representations.filter { $0.identifier != nil }
        let identifierToFetch = plantsWithID.compactMap { UUID(uuidString: $0.identifier!) }
        let representationsById = Dictionary(uniqueKeysWithValues: zip(identifierToFetch, plantsWithID))
        var plantsToCreate = representationsById
        
        let fetchRequest: NSFetchRequest<Plant1> = Plant1.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifierToFetch) // NSPredicate is how you filter in CoreData
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
            context.performAndWait {
                do {
                    let existingPlants = try context.fetch(fetchRequest)
                    
                    for plant in existingPlants {
                        guard let id = plant.identifier,
                        let representation = representationsById[id] else { continue }
                        self.update(plant: plant, with: representation)
                        plantsToCreate.removeValue(forKey: id)
                    }
                    
                    for representation in plantsToCreate.values {
                        Plant1(plantRepresentation: representation, context: context)
                    }
                } catch {
                    print("Error Fetching plants: \(error)")
                }
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    print("error saving to Database")
                }
            }
 
            }

private func update(plant: Plant1, with representation: PlantRepresentation) {
    plant.nickname = representation.nickname
    plant.species = representation.species
    plant.h2oFrequencyPerWeek = representation.h2oFrequencyPerWeek
}
}
