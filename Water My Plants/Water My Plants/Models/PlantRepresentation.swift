//
//  PlantRepresentation.swift
//  Water My Plants
//
//  Created by Sal B Amer on 2/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

// translation layer for coredata and future JSON endpoint

struct PlantRepresentation: Codable {
    var nickname: String?
    var species: String?
    var id: UUID?
    var h2oFrequencyPerWeek: String?
    var time: String?
    var startingDayOfWeek: String?
    var image: String?
}
