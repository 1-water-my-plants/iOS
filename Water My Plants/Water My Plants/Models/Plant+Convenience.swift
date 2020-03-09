//
//  Plant+Convenience.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

//extension FakeData {
//    convenience init(plant: String,
//                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        self.init(context: context)
//
//        self.plant = plant
//    }
//}

extension Plant1 {
   
       var plantRepresentation: PlantRepresentation? {
           guard let nickname = nickname,
           let species = species,
           let identifier = identifier,
           let h2oFrequencyPerWeek = h2oFrequencyPerWeek,
           let time = time,
//           let plantImage = plantImage,
           let startingDayOfWeek = startingDayOfWeek else { return nil }
           
//        return PlantRepresentation(nickname: nickname, species: species, identifier: identifier.uuidString, h2oFrequencyPerWeek: h2oFrequencyPerWeek, time: time, startingDayOfWeek: startingDayOfWeek, plantImage: plantImage.base64EncodedString()) // IMAGES Not working fix later
        
        return PlantRepresentation(nickname: nickname, species: species, identifier: identifier.uuidString, h2oFrequencyPerWeek: h2oFrequencyPerWeek, time: time, startingDayOfWeek: startingDayOfWeek)
       }
       
       @discardableResult convenience init(nickname: String?,
                        species: String?,
                        identifier: UUID = UUID(),
                        h2oFrequencyPerWeek: String,
                        time: Date = Date(),
                        startingDayOfWeek: String,
//                        plantImage: Data,
                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
           self.init(context: context)
           self.nickname = nickname
           self.species = species
           self.identifier = identifier
           self.h2oFrequencyPerWeek = h2oFrequencyPerWeek
           self.time = time
           self.startingDayOfWeek = startingDayOfWeek
//           self.plantImage = plantImage
       }
       
       @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
           guard let nickname = plantRepresentation.nickname,
               let species = plantRepresentation.species,
               let identifierString = plantRepresentation.identifier,
               let identifier = UUID(uuidString: identifierString),
               let h2oFrequencyPerWeek = plantRepresentation.h2oFrequencyPerWeek,
               let time = plantRepresentation.time,
//                let plantImage = Data(base64Encoded: plantRepresentation.plantImage!), // double check later
               let startingDayOfWeek = plantRepresentation.startingDayOfWeek else { return nil }
           
        self.init(nickname: nickname, species: species, identifier: identifier, h2oFrequencyPerWeek: h2oFrequencyPerWeek, time: time, startingDayOfWeek: startingDayOfWeek)
       }
    
 }
