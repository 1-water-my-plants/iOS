//
//  Plant+Convenience.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Plant {
 
    
    var plantRepresentation: PlantRepresentation? {
    guard let nickname = nickname,
    let species = species,
    let id = id,
    let h2oFrequencyPerWeek = h2oFrequencyPerWeek,
    let time = time,
    let startingDayOfWeek = startingDayOfWeek,
    let image = image else { return nil }

        return PlantRepresentation(nickname: nickname, species: species, id: id.uuidString, h2oFrequencyPerWeek: h2oFrequencyPerWeek, time: time, startingDayOfWeek: startingDayOfWeek, image: image.base64EncodedString())

     }
    
    @discardableResult convenience init(nickname: String? = nil, species: String? = nil, id: UUID = UUID(),h2oFrequencyPerWeek: String? = nil, time: String? = nil , startingDayOfWeek: String? = nil, image: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
         self.init(context:context)
                 self.nickname = nickname
                 self.species = species
                 self.id = id
                 self.h2oFrequencyPerWeek = h2oFrequencyPerWeek
                 self.time = time
                 self.startingDayOfWeek = startingDayOfWeek
//                 self.image = image?.base64EncodedString()
                self.image = Data(base64Encoded: image)

             }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let nickname = plantRepresentation.nickname,
            let species = plantRepresentation.species,
            let identifierString = plantRepresentation.id,
            let identifier = UUID(uuidString: identifierString),
            let h2oFrequencyPerWeek = plantRepresentation.h2oFrequencyPerWeek,
            let time = plantRepresentation.time,
            let startingDayOfWeek = plantRepresentation.startingDayOfWeek,
            let imageData = plantRepresentation.image,
            let image = Data(base64Encoded: imageData) else { return nil }
        
        self.init(nickname: plantRepresentation.nickname ?? "buggyNickname",
                species: plantRepresentation.species ?? "buggySpecies",
                id: identifier,
                h2oFrequencyPerWeek: plantRepresentation.h2oFrequencyPerWeek ?? "buggyFrequency",
                time: plantRepresentation.time,
                startingDayOfWeek: plantRepresentation.startingDayOfWeek,
                image: plantRepresentation.image ?? "buggyImage",
                context: context)
    }
    
}


 
//
//struct PlantRepresentation: Codable {
//    var nickname: String?
//    var species: String?
//    var id: UUID?
//    var h2oFrequencyPerWeek: String?
//    var time: String?
//    var startingDayOfWeek: String?
//    var image: String?
//}
