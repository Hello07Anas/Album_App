//
//  Untitled.swift
//  Album
//
//  Created by anas on 28/02/2025.
//

import Combine

class ProfileViewModel: ObservableObject {
    private let networkService: NetworkServiceProtocol
    @Published var userAlbums: [Album] = []
    @Published var users: [User] = []
    private var cancellables = Set<AnyCancellable>()

    init(networkService: NetworkServiceProtocol = NetworkManager()) {
        self.networkService = networkService
    }

    func fetchAlbums(for userId: Int) {
        networkService.request(APIService.getAlbums(userID: userId))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching albums: \(error)")
                }
            }, receiveValue: { [weak self] albums in
                self?.userAlbums = albums
            })
            .store(in: &cancellables)
    }
    
    func fetchUsers(completion: (() -> Void)? = nil) {
        networkService.request(APIService.getUsers)
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    print("Error fetching users: \(error)")
                }
                completion?()
            }, receiveValue: { [weak self] users in
                guard let self = self else { return }
                self.users = users

                if let randomUser = users.randomElement() {
                    print("Selected User ID: \(randomUser.id)")
                    self.fetchAlbums(for: randomUser.id)
                }
            })
            .store(in: &cancellables)
    }
}
