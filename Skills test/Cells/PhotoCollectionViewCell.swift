//
//  PhotoCollectionViewCell.swift
//  Skills test
//
//  Created by Luis Salazar on 2/16/22.
//

import UIKit

// MARK: - PhotoCollectionViewCell
class PhotoCollectionViewCell: UICollectionViewCell {
    
     // MARK: Reuse Identifier
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }

    // MARK: Variables
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle functions
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }

    // MARK: Public functions
    public func startIndicator() {
        indicator.startAnimating()
    }
    
    public func setImage(_ image: UIImage) {
        indicator.stopAnimating()
        imageView.image = image
    }

    
}
