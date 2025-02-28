//
//  AlbumDetails.swift
//  Album
//
//  Created by anas on 28/02/2025.
//

import UIKit
import Combine

class AlbumDetailsVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = AlbumDetailsVM()
    private var cancellables = Set<AnyCancellable>()
    var albumId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCell()
        setupCollectionViewLayout()
        
        bindViewModel()
        viewModel.fetchPhotos(for: albumId)
    }

    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                self?.collectionView.reloadData()
                photos.forEach { photo in
                    print("Fetched photo: \(photo.id)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let itemsPerRow: CGFloat = 3
        let padding: CGFloat = 10
        let totalSpacing = (itemsPerRow - 1) * padding
        let cellWidth = (collectionView.frame.width - totalSpacing) / itemsPerRow

        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        
        collectionView.collectionViewLayout = layout
    }
    
    private func setUpCell() {
        let nib = UINib(nibName: "PhotoCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "PhotoCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CollectionToDetailSegue",
           let destinationVC = segue.destination as? ZoomingVC,
           let indexPath = sender as? IndexPath,
           let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            
            destinationVC.imageUrl = cell.displayedURL
        }
    }
}

extension AlbumDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = viewModel.photos[indexPath.item]
        cell.configure(with: photo.url, index: indexPath.item)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            if let displayedURL = cell.displayedURL {
                print("Selected Image URL: \(displayedURL)")
            } else {
                print("No image URL available for this cell.")
            }
        }
        
        performSegue(withIdentifier: "CollectionToDetailSegue", sender: indexPath)
    }
}

extension AlbumDetailsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText is \(searchText)")
        viewModel.filterPhotos(query: searchText)
    }
}
