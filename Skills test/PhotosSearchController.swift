//
//  PhotosSearchController.swift
//  Skills test
//
//  Created by Luis Salazar on 2/17/22.
//

import UIKit

// MARK: - PhotosSearchDelegate
protocol PhotosSearchDelegate {
    func photosSearched(searchText: String?)
}

// MARK: - PhotosSearchController
class PhotosSearchController: UISearchController {
    // MARK: Delegates
    var photosSearchDelegate: PhotosSearchDelegate?

    // MARK: Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

// MARK: - UISearchBarDelegate
extension PhotosSearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        photosSearchDelegate?.photosSearched(searchText: searchBar.text)
        searchBar.text = ""
        dismiss(animated: true)
    }
    
}
