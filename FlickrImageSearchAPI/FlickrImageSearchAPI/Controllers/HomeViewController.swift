//
//  HomeViewController.swift
//  FlickrImageSearchAPI
//
//  Created by Vinay B. Naikade on 31/01/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var querySearchBar: UISearchBar!
    @IBOutlet weak var flickrImageCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: CustomLoader!
    
    private let viewModel = PhotosViewModel()
    
    private func bindData() {
        viewModel.photos.bind { [weak self] images in
            DispatchQueue.main.async {
                self?.flickrImageCollectionView.reloadData()
            }
        }
        viewModel.isLoading.bind { [weak self] isLoading in
            if isLoading {
                self?.loadingView.startLoading()
            } else {
                self?.loadingView.stopLoading()
            }
        }
        viewModel.loadingText.bind { [weak self] loadingText in
            self?.loadingView.loadingText = loadingText
        }
        viewModel.apiError.bind { [weak self] error in
            guard error != .none else { return }
            DispatchQueue.main.async {
                self?.showAlert(message: error.rawValue)
            }
        }
    }
    
    private func initializeFlickrImageCollectionView() {
        flickrImageCollectionView.register(UINib(nibName: "FlickrImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: FlickrImageCollectionViewCell.reuseIdentifier)
        flickrImageCollectionView.keyboardDismissMode = .onDrag
        flickrImageCollectionView.dataSource = self
        flickrImageCollectionView.delegate = self
    }
    
    private func initializeQuerySearchBar() {
        querySearchBar.placeholder = CommonStrings.searchHere.rawValue
        querySearchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindData()
        initializeFlickrImageCollectionView()
        initializeQuerySearchBar()
        viewModel.loadNextBatch()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrImageCollectionViewCell.reuseIdentifier, for: indexPath) as! FlickrImageCollectionViewCell
        cell.setFlickrImage(photo: viewModel.photos.value[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width / 3.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.count - 1 == indexPath.item {
            viewModel.loadNextBatch(fromPagination: true)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
   
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        querySearchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchingText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        searchBar.showsCancelButton = false
        viewModel.searchingText = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.searchingText = searchText
        viewModel.reset()
    }
}
