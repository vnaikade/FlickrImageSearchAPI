//
//  FlickrImage.swift
//  FlickrImageSearchAPI
//
//  Created by Vinay B. Naikade on 31/01/22.
//

import Foundation

let photoUrlFormat = "http://farm%@.static.flickr.com/%@/%@_%@.jpg"

struct Photos: Codable {
    let photos: PhotosData
}

struct PhotosData: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [FlickrImage]
}

struct FlickrImage: Codable {
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    
}
