//
//  HTTPManager.swift
//  NYT
//
//  Created by Steven Curtis on 29/04/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public protocol HTTPManagerProtocol {
    func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void)
    init(session: URLSessionProtocol)
}

class HTTPManager {

    /// A URLProtocol instance that is replaced by the URLSession in production code
    fileprivate let session: URLSessionProtocol

    /// required initiation of the HTTPManager instance
    required init(session: URLSessionProtocol) {
        self.session = session
    }
    
    /// Errors that will be generated by the HTTPManager
    enum HTTPError: Error {
        case invalidURL
        case noInternet
        case invalidResponse(Data?, URLResponse?)
    }
    
    ///  Get data through an API call using a URL, returning a result type
    ///
    /// - Parameters:
    ///   - url: A URL represting the location of the resource
    ///   - completionBlock: A completion closure returning the result type
    public func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        // make sure we pull new data each time
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }
            
            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    if let data = data {
                        completionBlock(.success(data))
                    } else {
                        completionBlock(.failure(HTTPError.invalidResponse(data, response)))
                    }
                    return
            }
            completionBlock(.success(responseData))
        }
        task.resume()
    }
}



extension URLSession: URLSessionProtocol {}

extension HTTPManager : HTTPManagerProtocol {}
