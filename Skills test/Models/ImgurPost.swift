//
//  ImgurPost.swift
//  Skills test
//
//  Created by Luis Salazar on 2/20/22.
//

import Foundation

// MARK: - ImgurResponse
/// This is how we get the whole data from the Imgur API. It's only use for decoding.
struct ImgurResponse: Codable {
    let data: [ImgurPost]
}

// MARK: - ImgurPost
/// ImgurPost Model is a representation of the posts we get from Imgur API.
struct ImgurPost: Codable {
    // MARK: Private Variables
    private let id: String
    
    // MARK: Public Variables
    /// isAlbum is needed to filter the posts
    public let isAlbum: Bool
    public var images: [ImgurImage]?
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case isAlbum = "is_album"
        case images
    }
}
