//
//  MockURLSession.swift
//  BasicHTTPManagerTests
//
//  Created by Steven Curtis on 07/03/2020.
//  Copyright © 2020 Steven Curtis. All rights reserved.
//

import Foundation
@testable import BasicHTTPManager

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

protocol URLSessionAccessProtocol {
    func responseSuccess(willSucceed: Bool)
    func setData(data: Data?)
    func setURLResponse(response: URLResponse)
    func setStatusCode(code: Int)
}

typealias URLSessionMock = URLSession & URLSessionAccessProtocol

class MockURLSession: URLSessionMock {
    func setStatusCode(code: Int) {
        self.code = code
    }
    
    func setData(data: Data?) {
        self.data = data
    }

    func setURLResponse(response: URLResponse) {
        self.response = response
    }
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func responseSuccess(willSucceed: Bool) {
        self.willSucceed = willSucceed
    }
    
    var willSucceed = true
    let shared = self
    var data: Data?
    var error: Error?
    var response: URLResponse?
    var code: Int = 200
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if willSucceed {
            let data = self.data
            let error = self.error
            let code = self.code
            return MockURLSessionDataTask {
                completionHandler(data, HTTPURLResponse(url: (request.url ?? URL(string: "http://www.ask.com")! ), statusCode: code, httpVersion: "1.1.0", headerFields: nil), error)
            }
        }
        else {
            let data = self.data
            let error = NSError.init(domain: "Mock Error", code: 100)
            return MockURLSessionDataTask {
                completionHandler(data, nil, error)
            }
        }
    }

    
}
