//
//  URLSessionProtocol.swift
//  BasicHTTPManager
//
//  Created by Steven Curtis on 07/03/2020.
//  Copyright © 2020 Steven Curtis. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
