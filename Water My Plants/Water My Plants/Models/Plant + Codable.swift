//
//  Plant + Codable.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/1/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension Plant1: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(nickname, forKey: .nickname)
        try container.encode(species, forKey: .species)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(h2oFrequencyPerWeek, forKey: .h2oFrequencyPerWeek)
        try container.encode(time, forKey: .time)
        try container.encode(startingDayOfWeek, forKey: .startingDayOfWeek)
    }
    enum CodingKeys: String, CodingKey {
        case nickname
        case species
        case identifier
        case h2oFrequencyPerWeek
        case time
        case startingDayOfWeek
    }
}
