//
//  Untitled.swift
//  Album
//
//  Created by anas on 28/02/2025.
//

import Moya
import Foundation

enum APIService {
    case getUsers
    case getAlbums(userID: Int)
    case getPhotos(albumID: Int)
}

extension APIService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: URLs.baseURL.rawValue) else { // https://jsonplaceholder.typicode.com
            fatalError("Invalid base URL")
        }
        return url
    }

    var path: String {
        switch self {
        case .getUsers:
            return "users"
        case .getAlbums:
            return "albums"
        case .getPhotos:
            return "photos"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .getUsers:
            return .requestPlain
        case .getAlbums(let userID):
            return .requestParameters(parameters: [K.userId: userID], encoding: URLEncoding.default)
        case .getPhotos(let albumID):
            return .requestParameters(parameters: [K.albumId: albumID], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        nil
    }
}
