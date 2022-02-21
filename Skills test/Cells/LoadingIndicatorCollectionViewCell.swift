//
//  LoadingIndicatorCollectionViewCell.swift
//  Skills test
//
//  Created by Luis Salazar on 2/19/22.
//

import UIKit

// MARK: - LoadingIndicatorCollectionViewCell
/// This class shows a large loading activiity indicator
class LoadingIndicatorCollectionViewCell: UICollectionViewCell {
    
    // MARK: Reuse Identifier
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }

    // MARK: Variables
    private var indicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public functions
    public func startIndicator() {
        indicator.startAnimating()
    }
    
}
