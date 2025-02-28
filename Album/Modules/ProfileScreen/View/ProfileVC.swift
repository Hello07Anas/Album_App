//
//  ProfileVC.swift
//  Album
//
//  Created by anas on 28/02/2025.
//

import UIKit
import Combine

class ProfileVC: UIViewController {
    
    @IBOutlet weak var userNameOT: UILabel!
    @IBOutlet weak var userAddressOT: UILabel!
    @IBOutlet weak var listOfAlbums: UITableView!
    
    
    private let viewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.fetchUsers()
    }

    @IBAction func changeUserTapped(_ sender: UIBarButtonItem) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()

        let originalButton = sender.customView
        sender.customView = activityIndicator

        viewModel.fetchUsers {
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                sender.customView = originalButton
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.$userAlbums
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.listOfAlbums.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                guard let self = self, let randomUser = users.randomElement() else { return }
                self.userNameOT.text = randomUser.name
                self.userAddressOT.text = "\(randomUser.address.street), \(randomUser.address.suite), \(randomUser.address.city) , \(randomUser.address.zipcode)"
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotosSegue",
           let destinationVC = segue.destination as? AlbumDetailsVC,
           let selectedIndex = listOfAlbums.indexPathForSelectedRow?.row {
            let selectedAlbum = viewModel.userAlbums[selectedIndex]
            destinationVC.albumId = selectedAlbum.id
        }
    }


}

// MARK: - TableView.. 

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        cell.textLabel?.text = viewModel.userAlbums[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Albums"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
