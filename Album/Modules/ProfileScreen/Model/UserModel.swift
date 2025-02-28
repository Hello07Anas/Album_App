//
//  UserModel.swift
//  Album
//
//  Created by anas on 28/02/2025.
//

struct User: Codable {
    let id: Int
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}
