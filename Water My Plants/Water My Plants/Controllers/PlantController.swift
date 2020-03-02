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

let plantRepresentation = PlantRepresentation()

class PlantController {
    
    // type alias - sort of shortcut for function - put outsude class to use throughout class.
    typealias CompletionHandler = (Error?) -> Void
    
    // fetch tasks from controller
    init() {
        fetchTasksFromServer()
    }
    
    func fetchTasksFromServer(completion: @escaping CompletionHandler =  { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json") // can append json instead of using firebase SDK
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
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
                let plantRepresentations = Array(try JSONDecoder().decode([String : PlantRepresentation].self, from: data).values)
                // update tasks
                try self.updateTasks(with: plantRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
                print("Error decoding plant representation: \(error)")
            }
        }.resume()
    }
    
     // send tasks to server from local changes
    
    func sendTaskToServer(plant: Plant, completion: @escaping CompletionHandler = {_ in }) {
        let uuid = plant.id ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = plant.plantRepresentation else { completion(NSError())
            return }
            representation.id = uuid.uuidString
            plant.id = uuid
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext) // Save on main context
//            try saveToPersistentStore()  - OLD method
            request.httpBody = try JSONEncoder().encode(representation)
            
        } catch {
            print("Error encoding task \(plant): \(error)")
            completion(error)
            return
        }
        //send new task to api
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
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
    
    //delete
    
    func deleteTaskFromServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = plant.id else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
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
    
    
    // update tasks
    func updateTasks(with representations: [PlantRepresentation]) throws {
        let tasksWithID = representations.filter { $0.id != nil }
        let identifierToFetch = tasksWithID.compactMap { ($0.id!) }  // compactMap will drop all nils so Bang operator is ok
        let representationsById = Dictionary(uniqueKeysWithValues: zip(identifierToFetch, tasksWithID))
        var tasksToCreate = representationsById

        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifierToFetch) // NSPredicate is how you filter in CoreData

        let context = CoreDataStack.shared.container.newBackgroundContext() // NEW Way
//        let context = CoreDataStack.shared.mainContext // Old way with background thread

        context.perform {
            do {
                    let existingTasks = try context.fetch(fetchRequest)

                    for task in existingTasks {
                        guard let id = plantRepresentation.id,
                        let representation = representationsById[id] else { continue }
                        self.update(plant: task, with: representation)
                        tasksToCreate.removeValue(forKey: id)
                    }
                    for representation in tasksToCreate.values {
                        Plant(plantRepresentation: representation, context: context)
                    }
                } catch {
                    print("Error Fetching tasks for UUIDs: \(error)")
                }

//                try self.saveToPersistentStore() -- OLD method
            do {
               try CoreDataStack.shared.save(context: context)
            } catch {
                print("Error saving to Database")
            }


            }
        }

        
    
    private func update(plant: Plant, with representation: PlantRepresentation) {
        plant.nickname = representation.nickname
        plant.species = representation.species
        plant.h2oFrequencyPerWeek = representation.h2oFrequencyPerWeek
        plant.time = representation.time
    }
    
////     old method - Use Concurrency save method in CoreDataStack
//    private func saveToPersistentStore() throws {
//        let moc = CoreDataStack.shared.mainContext
//        try moc.save()
//    }
}
 

//struct PlantRepresentation: Codable, Equatable {
//    var nickname: String?
//    var species: String?
//    var id: String?
//    var h2oFrequencyPerWeek: String?
//    var time: String?
//    var startingDayOfWeek: String?
//    var image: String?
//}
