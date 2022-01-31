//
//  ImageDownlodService.swift
//  FlickrImageSearchAPI
//
//  Created by Vinay B. Naikade on 29/01/22.
//

import Foundation

class ImageDownlodService: BaseService {
    
    static let shared = ImageDownlodService()
    
    func getPhoto(with url: URL, completion: @escaping CompletionHandler) {
        type = .imageDownloading
        urlRequest = URLRequest(url: url)
        call(completion: completion)
    }
    
}
