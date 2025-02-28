//
//  PhotoModel.swift
//  Album
//
//  Created by anas on 28/02/2025.
//

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
