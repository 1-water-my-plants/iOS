//
//  PlantRepresentation.swift
//  Water My Plants
//
//  Created by Sal B Amer on 2/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

// translation layer for coredata and future JSON endpoint ( Node express )

struct PlantRepresentation: Codable {
    var nickname: String?
    var species: String?
    var identifier: String?
    var h2oFrequencyPerWeek: String?
    var time: Date?
    var startingDayOfWeek: String?
//    var image: String?
}

//func ==(lhs: PlantRepresentation, rhs: Plant1) -> Bool {
//    return rhs.nickname == lhs.nickname &&
//        rhs.species == rhs.species &&
//        rhs.id == lhs.id &&
//        rhs.startingDayOfWeek == lhs.startingDayOfWeek
//}
//
//func ==(lhs: Plant1, rhs: PlantRepresentation) -> Bool {
//    return rhs == lhs
//}
//
//func !=(lhs: PlantRepresentation, rhs: Plant1) -> Bool {
//    return !(rhs == lhs)
//}
//
//func !=(lhs: Plant1, rhs: PlantRepresentation) -> Bool {
//    return rhs != lhs
//}
