//
//  PhotosCollectionViewLayout.swift
//  Skills test
//
//  Created by Luis Salazar on 2/18/22.
//

import UIKit

// MARK: PhotosCollectionViewLayout
class PhotosCollectionViewLayout: UICollectionViewFlowLayout {
    // MARK: Constants
    private struct Constants {
        static let numberOfCellsPerRow = 3.0
        static let spacing = 1.0
        static let inset = 0.0
        static let indicatorHeight = 80.0
    }
    
    // MARK: Variables
    private (set) var photoSize = CGSize()
    private (set) var indicatorSize = CGSize()
    
    // MARK: Init
    override init() {
        super.init()

        sectionInset = .init(top: Constants.inset, left: Constants.inset, bottom: Constants.inset, right: Constants.inset)
        minimumInteritemSpacing = Constants.spacing
        minimumLineSpacing = Constants.spacing
        scrollDirection = .vertical
        
        let screenWidth = UIScreen.main.bounds.width
        let interItemSpacing = minimumInteritemSpacing * (Constants.numberOfCellsPerRow - 1.0)
        let inset = sectionInset.left + sectionInset.right
        let side = Int((screenWidth - interItemSpacing - inset) / Constants.numberOfCellsPerRow)

        indicatorSize = CGSize(width: screenWidth, height: Constants.indicatorHeight)
        photoSize = CGSize(width: side, height: side)
        itemSize = CGSize(width: side, height: side)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
