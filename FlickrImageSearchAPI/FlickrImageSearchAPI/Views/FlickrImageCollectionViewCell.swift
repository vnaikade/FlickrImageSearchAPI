//
//  FlickrImageCollectionViewCell.swift
//  FlickrImageSearchAPI
//
//  Created by Vinay B. Naikade on 29/01/22.
//

import UIKit

class FlickrImageCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FlickrImageCollectionViewCell"
    
    @IBOutlet weak var flickrImageView: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    private func initialization() {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        flickrImageView.image = nil
        flickrImageView.contentMode = .scaleAspectFit
        loadingView.hidesWhenStopped = true
        loadingView.stopAnimating()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialization()
    }

    private func getFormattedUrlForPhoto(photo: FlickrImage) -> URL? {
        let urlString = String(format: photoUrlFormat, "\(photo.farm)", photo.server, photo.id, photo.secret)
        return URL(string: urlString)
    }
    
    func setFlickrImage(photo: FlickrImage) {
        if let photoUrl = getFormattedUrlForPhoto(photo: photo) {
            if let photo = ImageCacheManager.shared.getCachedImage(for: photoUrl) {
                loadingView.stopAnimating()
                flickrImageView.image = photo
            } else {
                loadingView.startAnimating()
                ImageDownlodService.shared.getPhoto(with: photoUrl) { [weak self] result in
                    DispatchQueue.main.async {
                        self?.loadingView.stopAnimating()
                        switch result {
                        case .success(let data):
                            self?.flickrImageView.image = UIImage(data: data as! Data)
                        case .failure(_):
                            self?.flickrImageView.image = nil
                        }
                    }
                }
            }
        }
    }
}
