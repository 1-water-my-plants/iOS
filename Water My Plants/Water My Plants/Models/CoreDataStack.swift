//
//  CoreDataStack.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Plants")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load peristent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
     
    var mainContext: NSManagedObjectContext {  // created mamaged object context
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext) throws {
        var saveError: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch {
                saveError = error
            }
        }
        if let saveError = saveError { throw saveError }
        
    }
}
