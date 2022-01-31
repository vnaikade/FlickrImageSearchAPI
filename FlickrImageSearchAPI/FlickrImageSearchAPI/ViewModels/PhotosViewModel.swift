//
//  PhotosViewModel.swift
//  FlickrImageSearchAPI
//
//  Created by Vinay B. Naikade on 31/01/22.
//

import Foundation

typealias Completion = (Bool) -> Void

class PhotosViewModel {
    
    private var currentPage = 0
    private var totalPages = 1
    private var photosPerPage = 0
    
    var photos: DataBinder<Array<FlickrImage>> = DataBinder(Array())
    var isLoading = DataBinder(false)
    var searchingText = "" {
        didSet {
            loadingText.value = searchingText.isEmpty ? .loading : .searching
        }
    }
    var apiError: DataBinder<APIError> = DataBinder(APIError.none)
    var loadingText: DataBinder<LoadingText> = DataBinder(.loading)
    
    private func add(_ photos: [FlickrImage]) {
        self.photos.value.append(contentsOf: photos)
    }
    
    private func removeAll() {
        photos.value.removeAll()
    }
    
    var count: Int {
        return photos.value.count
    }
    
    func loadNextBatch(fromPagination: Bool = false) {
        guard !isLoading.value, currentPage <= totalPages, currentPage != totalPages else { return }
        currentPage = fromPagination ? currentPage + 1 : !searchingText.isEmpty ? 1 : currentPage + 1
        isLoading.value = true
        FlickrPhotoSerachService.shared.getPhotos(for: currentPage, with: searchingText) { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let photos):
                self?.totalPages = (photos as! Photos).photos.total
                self?.photosPerPage = (photos as! Photos).photos.perpage
                self?.add((photos as! Photos).photos.photo)
            case .failure(let error):
                self?.apiError.value = error
            }
        }
    }
    
    func reset() {
        currentPage = 0
        totalPages = 1
        photosPerPage = 0
        removeAll()
        loadNextBatch()
    }
}
