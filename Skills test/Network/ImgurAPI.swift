//
//  ImgurAPI.swift
//  Skills test
//
//  Created by Luis Salazar on 2/20/22.
//

import Foundation

// MARK: - ImgurAPI
/// ImgurAPI class in charge of doing the calls to the API and storing all the appi related information.
final class ImgurAPI {
    // MARK: Constants
    private struct Constants {
        static let baseURL = "https://api.imgur.com"
        static let clientID = "311250c7d7d9788"
        static let httpHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Client-ID \(Constants.clientID)",
            "Host": "api.imgur.com"
        ]
        static let searchQueryName = "q_any"
        static let filterQueryName = "q_type"
        static let jpgType = "jpg"
        static let searchPath = "/3/gallery/search/top/"
    }

    // MARK: Variables
    private let networkManager = NetworkManager(httpHeaderFields: Constants.httpHeaderFields)
    private var latestQuery = ""
    
    // MARK: Public functions
    /// Loads the photos from the Imgur Search Gallery API.
    /// - Parameters:
    ///   - text: Text for the search query
    ///   - page: Page requested to the API. Starts at 0
    ///   - completion: completion handler that returns tan array of ImgurPost
    public func loadPhotos(text: String, page: Int, completion: @escaping ([ImgurPost]) -> Void) {
        let searchQuery = URLQueryItem(name: Constants.searchQueryName, value: text)
        let filterTypeQuery = URLQueryItem(name: Constants.filterQueryName, value: Constants.jpgType)
        guard var components = URLComponents(string: Constants.baseURL) else { return }
        components.path = Constants.searchPath + "\(page)/"
        components.queryItems = [
            searchQuery,
            filterTypeQuery
        ]
        
        guard let url = components.url else { return }
        latestQuery = url.absoluteString
        
        networkManager.request(url: url, method: .GET) { [weak self] (result: Result<ImgurResponse, Error>) in
            switch result {
            case .success(let imgurData):
                guard let self = self else { return }
                debugPrint("Succesful request with query: \(self.latestQuery)")

                // If latestQuery is different than url, it means a new request was made after this one, we only want to return the latest request.
                if self.latestQuery == url.absoluteString {
                    completion(imgurData.data)
                }
            case .failure(let error):
                debugPrint("Could not get data. Error: \(error.localizedDescription)")
            }
        }
    }
}
