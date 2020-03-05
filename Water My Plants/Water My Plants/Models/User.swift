//
//  User.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    let id: Int?
    let username: String?
    let password: String?
    let phoneNumber: String?
    let message: String
    let token: String?
    let user_id: Int?
}
