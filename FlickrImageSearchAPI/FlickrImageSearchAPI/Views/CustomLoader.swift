//
//  CustomLoader.swift
//  FlickrImageSearchAPI
//
//  Created by Vinay B. Naikade on 29/01/22.
//

import UIKit

enum LoadingText: String {
    case loading
    case searching
    
    var rawValue: String {
        switch self {
        case .loading:
            return CommonStrings.loading.rawValue
        case .searching:
            return CommonStrings.searching.rawValue
        }
    }
}

class CustomLoader: UIView {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var loadingTextLabel: UILabel!
    
    var loadingText: LoadingText = .loading {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.loadingTextLabel.text = self?.loadingText.rawValue
            }
        }
    }
    
    private func initialSetUpView() {
        loader.hidesWhenStopped = true
        loadingTextLabel.font = .preferredFont(forTextStyle: .headline)
        loadingTextLabel.textColor = .black
    }
    
    private func viewFromNib() -> UIView {
        let view = viewFromNib(nib: CustomLoader.self, owner: self)
        return view
    }
    
    private func setUpView() {
        let view = viewFromNib()
        view.frame = bounds
        backgroundColor = .clear
        addSubview(view)
    }
    
    // MARK:- Lifecycle methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        initialSetUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUpView()
    }
    
    func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loader.startAnimating()
            self?.isHidden = false
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loader.stopAnimating()
            self?.isHidden = true
        }
    }
}
