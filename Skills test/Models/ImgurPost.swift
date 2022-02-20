//
//  ImgurPost.swift
//  Skills test
//
//  Created by Luis Salazar on 2/20/22.
//

import Foundation

// MARK: - ImgurResponse
struct ImgurResponse: Codable {
    let data: [ImgurPost]
}

// MARK: - ImgurPost
struct ImgurPost: Codable {
    // MARK: Private Variables
    private let id: String
    
    // MARK: Public Variables
    public let isAlbum: Bool
    public var images: [ImgurImage]?
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case isAlbum = "is_album"
        case images
    }
}
