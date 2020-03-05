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
        let startingDayOfWeek = startingDayOfWeek else { return nil }
        
        return PlantRepresentation(nickname: nickname, species: species, identifier: identifier.uuidString, h2oFrequencyPerWeek: h2oFrequencyPerWeek, time: time, startingDayOfWeek: startingDayOfWeek)
    }
    
    @discardableResult convenience init(nickname: String?,
                     species: String?,
                     identifier: UUID = UUID(),
                     h2oFrequencyPerWeek: String,
                     time: Date = Date(),
                     startingDayOfWeek: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.nickname = nickname
        self.species = species
        self.identifier = identifier
        self.h2oFrequencyPerWeek = h2oFrequencyPerWeek
        self.time = time
        self.startingDayOfWeek = startingDayOfWeek
    }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let nickname = plantRepresentation.nickname,
            let species = plantRepresentation.species,
            let identifierString = plantRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString),
            let h2oFrequencyPerWeek = plantRepresentation.h2oFrequencyPerWeek,
            let time = plantRepresentation.time,
            let startingDayOfWeek = plantRepresentation.startingDayOfWeek else { return nil }
        
        self.init(nickname: nickname, species: species, identifier: identifier, h2oFrequencyPerWeek: h2oFrequencyPerWeek, time: time, startingDayOfWeek: startingDayOfWeek)
    }
    
//        @discardableResult convenience init(nickname: String, species: String, id: UUID = UUID(), h2oFrequencyPerWeek: String, time: String, startingDayOfWeek: String, image: Data?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//            self.init(context: context)
//            self.nickname = nickname
//
//        }
    
    
//    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        guard let nickname = plantRepresentation.nickname,
//            let species = plantRepresentation.species,
//            let id = plantRepresentation.id,
//            let h2oFrequencyPerWeek = plantRepresentation.h2oFrequencyPerWeek,
//            let time = plantRepresentation.time,
//            let startingDayOfWeek = plantRepresentation.startingDayOfWeek,
//            let image = plantRepresentation.image else { return }
//
//            self.init(nickname: nickname, species: species, id: id.uuidString, h2oFrequencyPerWeek: h2oFrequencyPerWeek, time: time, startingDayOfWeek: startingDayOfWeek, image: image)
//    }
    
}


//delete later
//var nickname: String?
//var species: String?
//var id: String?
//var h2oFrequencyPerWeek: String?
//var time: String?
//var startingDayOfWeek: String?
//var image: String?
