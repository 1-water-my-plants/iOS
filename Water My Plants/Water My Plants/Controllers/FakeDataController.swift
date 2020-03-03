//
//  FakeDataController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/1/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class FakeDataController {
    
    func create(plant: String) {
        FakeData(plant: plant)
        
        
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving to core data: \(error)")
        }
    }
    func fetch() {
        let fetchRequest: NSFetchRequest<FakeData> = FakeData.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            let plants = try moc.fetch(fetchRequest)
            for plant in plants {
                print(plant)
            }
        } catch {
            print("Error fetching: \(error)")
        }
    }
}
