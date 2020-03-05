//
//  Request.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct SignUpRequest: Codable, Equatable {
    let username: String
    let password: String
    let phoneNumber: String
}

struct LoginRequest: Codable, Equatable {
    let username: String
    let password: String
}

struct PlantRequest: Codable, Equatable {
    var id: Int?
    var nickname: String
    var species: String
    var h2oFrequency: Int
    var image: String
    var user_id: Int
}
