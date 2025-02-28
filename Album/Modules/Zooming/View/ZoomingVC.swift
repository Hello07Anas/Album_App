//
//  ScrollView.swift
//  Album
//
//  Created by anas on 28/02/2025.
//

import UIKit
import Kingfisher

class ZoomingVC: UIViewController {
    
    @IBOutlet weak var zoomingImgOT: UIImageView!
    
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageView()
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        if let image = zoomingImgOT.image {
            shareImage(image)
        }
    }
    
    // MARK: - Helper Methods..
    
    private func setUpImageView() {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            zoomingImgOT.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }
    
    /// Shares an image with optional exclusion of specific activity types if needed.
    func shareImage(_ image: UIImage, excludedActivities: [UIActivity.ActivityType] = []) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
        }
        
        activityViewController.excludedActivityTypes = excludedActivities
        
        self.present(activityViewController, animated: true, completion: nil)
    }

}

extension ZoomingVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomingImgOT
    }
}
