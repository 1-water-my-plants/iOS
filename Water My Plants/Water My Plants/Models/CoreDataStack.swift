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

    lazy var container: NSPersistentContainer = {   // create persistent store and persistant store container
        let newContainer = NSPersistentContainer(name: "Plants")
        newContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load peristent stores: \(error)")
            }
        }
        newContainer.viewContext.automaticallyMergesChangesFromParent = true
        return newContainer
    }()
     
    var mainContext: NSManagedObjectContext {  // created managed object context
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
