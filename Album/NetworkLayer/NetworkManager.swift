//
//  NetworkManager.swift
//  Album
//
//  Created by anas on 28/02/2025.
//

import Moya
import Combine
import Foundation
import CombineMoya


protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ target: APIService) -> AnyPublisher<T, Error>
}

class NetworkManager: NetworkServiceProtocol {
    private let provider = MoyaProvider<APIService>()

    func request<T: Decodable>(_ target: APIService) -> AnyPublisher<T, Error> {
        return provider.requestPublisher(target)
            .tryMap { response -> T in
                guard (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return try JSONDecoder().decode(T.self, from: response.data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
