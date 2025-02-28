//
//  PhotoCell.swift
//  Album
//
//  Created by anas on 28/02/2025.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var displayedURL: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        imageView.layer.cornerRadius = 8
    }
    
    func configure(with photoURL: String, index: Int) {
        print("===-=-=-=-=-=-=-=-=-=-====")
        print("url is: \(photoURL)")
        print("===-=-=-=-=-=-=-=-=-=-====")
        guard let url = URL(string: photoURL) else {
            imageView.image = UIImage(named: "placeholder")
            return
        }
        
        let fallbackURLString = "\(URLs.placeholdersURL.rawValue)?\(index)"
        guard let fallbackURL = URL(string: fallbackURLString) else { return }

        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            completionHandler: { result in
                switch result {
                case .success:
                    self.displayedURL = photoURL
                case .failure:
                    self.displayedURL = fallbackURL.absoluteString
                    self.imageView.kf.setImage(with: fallbackURL)
                }
            }
        )
    }
}

