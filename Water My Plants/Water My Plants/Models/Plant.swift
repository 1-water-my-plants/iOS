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
    var nickname: String?
    var species: String?
    var user_id: String?
    var h2oFrequency: String?
    var image: String?
    var id: String?
}
