//
//  NetworkManager.swift
//  Skills test
//
//  Created by Luis Salazar on 2/20/22.
//

import Foundation

// MARK: - NetworkManager
class NetworkManager {
    // MARK: Enums
    enum NetworkError: Error {
        case invalidResponse
        case invalidStatusCode(Int)
    }
    
    enum HttpMethod: String {
        case GET
    }
    
    // MARK: Variables
    private let httpHeaderFields: [String: String]?
    
    // MARK: Init
    init(httpHeaderFields: [String: String]? = [:]) {
        self.httpHeaderFields = httpHeaderFields
    }
    
    // MARK: Public functions
    public func request<T: Decodable>(url: URL, method: HttpMethod, completion: @escaping (Result<T, Error>) -> Void) {
        let completionOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = httpHeaderFields
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionOnMain(.failure(error))
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                return completionOnMain(.failure(NetworkError.invalidResponse))
            }
            
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(.failure(NetworkError.invalidStatusCode(urlResponse.statusCode)))
            }
            
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completionOnMain(.success(decodedData))
            } catch {
                debugPrint("Could not decode data to the requested type. Error: \(error.localizedDescription)")
                completionOnMain(.failure(error))
            }
        }
        
        task.resume()
    }
}
