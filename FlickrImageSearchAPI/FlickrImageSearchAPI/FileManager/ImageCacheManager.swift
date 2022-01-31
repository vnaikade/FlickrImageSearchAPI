//
//  ImageCacheManager.swift
//  FlickrImageSearchAPI
//
//  Created by Vinay B. Naikade on 29/01/22.
//

import Foundation
import UIKit

class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    let flickrImageFolder = "flickrImages"
    
    lazy var fileManager: FileManager = {
        let fileManager = FileManager.default
        return fileManager
    }()
    
    func chacheImageData(with key: String, imageData: Data) {
        let imageFile = flickrImageFolder + key
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageFileURL = dir.appendingPathComponent(imageFile)
            do {
                try imageData.write(to: imageFileURL)
            } catch {
                
            }
        }
    }
    
    func getCachedImage(for url: URL) -> UIImage? {
        let imageFile = flickrImageFolder + url.absoluteString
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageFilePath = dir.appendingPathComponent(imageFile).absoluteString
            guard fileManager.fileExists(atPath: imageFilePath) else { return nil }
            if let data = fileManager.contents(atPath: imageFilePath) {
                return UIImage(data: data)
            }
            return nil
        } else {
            return nil
        }
    }
    
    
}
