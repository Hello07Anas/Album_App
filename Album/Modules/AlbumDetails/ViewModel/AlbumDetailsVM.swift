//
//  AlbumDetailsVM.swift
//  Album
//
//  Created by anas on 28/02/2025.
//

import Combine

class AlbumDetailsVM: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private var allPhotos: [Photo] = []
    @Published var photos: [Photo] = []
    private var cancellables = Set<AnyCancellable>()

    init(networkService: NetworkServiceProtocol = NetworkManager()) {
        self.networkService = networkService
    }

    func fetchPhotos(for albumId: Int) {
        networkService.request(APIService.getPhotos(albumID: albumId))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching photos: \(error)")
                }
            }, receiveValue: { [weak self] photos in
                self?.allPhotos = photos
                self?.photos = photos
            })
            .store(in: &cancellables)
    }

    func filterPhotos(query: String) {
        if query.isEmpty {
            photos = allPhotos 
        } else {
            photos = allPhotos.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
    }
}



