//
//  Plant.swift
//  Water My Plants
//
//  Created by Sal B Amer on 2/28/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import UIKit


struct Plant: Codable, Equatable {
    var id: Int
    var nickname: String
    var species: String
    var h2oFrequency: Int
    var image: String?
    var user_id: Int
}
