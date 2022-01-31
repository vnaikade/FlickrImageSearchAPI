//
//  FlickrPhotoSerachService.swift
//  FlickrImageSearchAPI
//
//  Created by Vinay B. Naikade on 31/01/22.
//

import Foundation

enum APIError: Error {
    case none
    case networkError
    case responseError
    case noDataError
    case requestError
    case invalidDataError
    
    var rawValue: String {
        switch self {
        case .none:
            return ""
        case .networkError:
            return CommonStrings.pleaseCheckYourInternetConnection.rawValue
        case .responseError:
            return CommonStrings.unableToProcessFlickrApiResponse.rawValue
        case .noDataError:
            return CommonStrings.noDataReturnedFromFlickr.rawValue
        case .requestError:
            return CommonStrings.failedRequestFromFlickr.rawValue
        case .invalidDataError:
            return CommonStrings.unableToDecodeFlickrResponse.rawValue
        }
    }
}

enum WebServiceType {
    case api
    case imageDownloading
}

typealias CompletionHandler = (Result<Any, APIError>) -> Void
let timeOutIntervalForApi = 60

class BaseService {
    
    let apiKey = "2932ade8b209152a7cbb49b631c4f9b6"
    let host = "api.flickr.com"
    let path = "/services/rest/"
    var urlRequest: URLRequest!
    var type = WebServiceType.api
    
    lazy var commonUrlComponents: URLComponents = {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = path
        urlBuilder.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                                 URLQueryItem(name: "format", value: "json"),
                                 URLQueryItem(name: "nojsoncallback", value: "1"),
                                 URLQueryItem(name: "safe_search", value: "1")]
        return urlBuilder
    }()
    
    lazy var session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest =  TimeInterval(timeOutIntervalForApi)
        let session = URLSession(configuration: sessionConfiguration)
        return session
    }()
    
    func call(completion: @escaping CompletionHandler) {
        session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
               
            guard error == nil else {
                completion(.failure(.requestError))
                return
            }
            guard let responseData = data else {
                completion(.failure(.noDataError))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            guard response.statusCode == 200 else {
                completion(.failure(.requestError))
                return
            }
            if let type = self?.type {
                switch type {
                case .api:
                    completion(.success(responseData))
                case .imageDownloading:
                    if let actualImageUrl = response.url?.absoluteString {
                        ImageCacheManager.shared.chacheImageData(with: actualImageUrl, imageData: responseData)
                    }
                    completion(.success(responseData))
                }
            } else {
                completion(.success(responseData))
            }
            
        }.resume()
    }
}

enum FlickrApiMethod: String {
    case search = "flickr.photos.search"
    case recent = "flickr.photos.getRecent"
}

class FlickrPhotoSerachService: BaseService {
    
    static let shared = FlickrPhotoSerachService()
    
    private func getFormattedUrl(for page: Int, with serchText: String) -> URL {
        let additionalQueryItems = [
            URLQueryItem(name: "method", value: serchText.isEmpty ? FlickrApiMethod.recent.rawValue : FlickrApiMethod.search.rawValue),
            URLQueryItem(name: "text", value: serchText),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        commonUrlComponents.queryItems?.append(contentsOf: additionalQueryItems)
        return commonUrlComponents.url!
    }
    
    func getPhotos(for page: Int, with serchText: String, completion: CompletionHandler?) {
        urlRequest = URLRequest(url: getFormattedUrl(for: page, with: serchText))
        call { result in
            switch result {
            case .success(let data):
                do {
                  let decoder = JSONDecoder()
                    let photos: Photos = try decoder.decode(Photos.self, from: data as! Data)
                    completion?(.success(photos))
                } catch let error {
                    print(error)
                    completion?(.failure(.invalidDataError))
                }
            case .failure(let apiError):
                completion?(.failure(apiError))
            }
        }
    }
}
