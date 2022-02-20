//
//  ImgurImage.swift
//  Skills test
//
//  Created by Luis Salazar on 2/20/22.
//

import Foundation

// MARK: - ImgurImage
struct ImgurImage: Codable {
    // MARK: Private Variables
    private let type: String
    
    // MARK: Public Variables
    public let id: String
    public let link: String
    
    // MARK: Constants
    private struct Constants {
        static let baseImgURL = "https://i.imgur.com/"
        static let jpgExt = ".jpg"
        static let jpegType = "image/jpeg"
    }
    // MARK: Enums
    enum ThumbnailSize: String {
        case small = "t"
        case medium = "m"
    }

    // MARK: Public functions
    public func isJPEG() -> Bool {
        return type == Constants.jpegType
    }
    
    public func thumbnailURL(size: ThumbnailSize = .medium) -> URL? {
        let urlString = Constants.baseImgURL + id + size.rawValue + Constants.jpgExt
        return URL(string: urlString)
    }
}
