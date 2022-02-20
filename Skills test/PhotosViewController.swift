//
//  PhotosViewController.swift
//  Skills test
//
//  Created by Luis Salazar on 2/16/22.
//

import UIKit

// MARK: - PhotosViewController
class PhotosViewController: UIViewController {
    // MARK: Variables
    private let photosSearchController = PhotosSearchController()
    private let imgurAPI = ImgurAPI()
    private let photosCollectionViewLayout = PhotosCollectionViewLayout()

    private let cache = NSCache<NSString, UIImage>()
    private var images: [ImgurImage] = []
    private var page = 0
    private var searchText = ""
    private var isLoading = false
    
    // MARK: Constants
    private struct Constants {
        static let title = "Knock"
        static let queryTitle = "Query: "
        static let cacheCountLimit = 100
    }

    //MARK: IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = Constants.title
      
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        collectionView.register(LoadingIndicatorCollectionViewCell.self, forCellWithReuseIdentifier: LoadingIndicatorCollectionViewCell.reuseIdentifier)
        collectionView.collectionViewLayout = photosCollectionViewLayout
        
        // Set limit to NSCache so we don't use a lot of memory
        cache.countLimit = Constants.cacheCountLimit
        
        photosSearchController.photosSearchDelegate = self
        navigationItem.searchController = photosSearchController
    }
    
    // MARK: Private functions
    private func loadImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
                    
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    private func loadPhotos() {
        imgurAPI.loadPhotos(text: searchText, page: page) { [weak self] imgurPosts in
            guard let self = self else { return }
            self.isLoading = false
            
            let filteredImages = self.getImagesFromPosts(posts: imgurPosts)
            
            self.updateImages(newImages: filteredImages)
        }
    }
    
    private func loadPhotos(searchText: String) {
        isLoading = true
        images.removeAll()
        collectionView.reloadData()
        
        self.searchText = searchText
        page = 0
        
        loadPhotos()
    }
    
    private func loadMorePhotos() {
        if isLoading { return }
        
        isLoading = true
        page += 1
        
        loadPhotos()
    }
    
    private func getImagesFromPosts(posts: [ImgurPost]) -> [ImgurImage] {
        // Remove nil images
        let imagesArray = posts.compactMap { $0.images }
        // Flatten array
        let flattenImages = Array(imagesArray.joined())
        // Remove videos
        return flattenImages.filter { $0.isJPEG()}
    }
    
    private func updateImages(newImages: [ImgurImage]) {
        // Append new images to existing array
        images += newImages
        collectionView.reloadData()
    }
}


// MARK: - PhotosSearchDelegate
extension PhotosViewController: PhotosSearchDelegate {
    func photosSearched(searchText: String?) {
        guard let searchText = searchText else {
            title = Constants.title
            return
        }

        title = Constants.queryTitle + "\(searchText)"
        
        loadPhotos(searchText: searchText)
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return images.count
        } else {
            // loading indicator
            if !images.isEmpty || (images.isEmpty && isLoading) {
                return 1
            }
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let imageModel = images[indexPath.row]
            let imageId = imageModel.id as NSString
            
            if let cachedImage = self.cache.object(forKey: imageId) {
                print("Using a cached image for item: \(imageModel.id)")
                cell.setImage(cachedImage)
            } else {
                print("LOADING image for item: \(imageModel.id)")
                cell.startIndicator()

                guard let url = imageModel.thumbnailURL() else { return UICollectionViewCell() }

                self.loadImage(url: url) { [weak self] (image) in
                    guard let self = self, let image = image else { return }
                    cell.setImage(image)
                    self.cache.setObject(image, forKey: imageId)
                }
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingIndicatorCollectionViewCell.reuseIdentifier, for: indexPath) as? LoadingIndicatorCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.startIndicator()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isLoading && indexPath.section == 1  {
            loadMorePhotos()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        if section == 0 {
            // Photo Size
            return photosCollectionViewLayout.photoSize
        } else {
            // Indicator View size
            return photosCollectionViewLayout.indicatorSize
        }
    }
}

