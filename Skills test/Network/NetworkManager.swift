//
//  NetworkManager.swift
//  Skills test
//
//  Created by Luis Salazar on 2/20/22.
//

import Foundation

// MARK: - NetworkManager
/// NetworkManager class in charge of doing url requests
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
    /// Initialize NetworkManager with the httpHeaders
    /// - Parameter httpHeaderFields: The http header fields to be used in the ULRequest if needed.
    init(httpHeaderFields: [String: String]? = [:]) {
        self.httpHeaderFields = httpHeaderFields
    }
    
    // MARK: Public functions
    /// This function let us do a request and returns a completionHandler with the result. It's generic so it can be used with any type.
    /// - Parameters:
    ///   - url: URL for the request
    ///   - method: HttpMethod to be used. It only supports GET for now.
    ///   - completion: completion handler that returns the Generic object and error if any.
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
            
            // Ee only want results between 200 and 300 in status code.
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
