//
//  BasicHTTPManagerTests.swift
//  BasicHTTPManagerTests
//
//  Created by Steven Curtis on 05/03/2020.
//  Copyright © 2020 Steven Curtis. All rights reserved.
//

import XCTest
@testable import BasicHTTPManager

class BasicHTTPManagerTests: XCTestCase {
    
    var urlSession: MockURLSession?
    var httpManager: HTTPManager?

    override func setUp() {
        super.setUp()
        urlSession = MockURLSession()
        httpManager = HTTPManager(session: urlSession!)
    }

    func testFailureURLResponse() {
        urlSession = MockURLSession()
        urlSession?.responseSuccess(willSucceed: false)
        httpManager = HTTPManager(session: urlSession!)
        let expectation = XCTestExpectation(description: #function)
        let data = Data("test".utf8)
        urlSession?.data = data
        let url = URL(fileURLWithPath: "http://www.google.com")
        httpManager?.get(url: url) { result in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testBadlyFormattedURLResponse() {
        urlSession = MockURLSession()
        urlSession?.responseSuccess(willSucceed: true)
        urlSession?.setData(data: nil)
        httpManager = HTTPManager(session: urlSession!)
        let expectation = XCTestExpectation(description: #function)
        let url = URL(fileURLWithPath: "http://www.google.com")
        httpManager?.get(url: url) {result in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSuccessfulDataResponse(){
        urlSession = MockURLSession()
        httpManager = HTTPManager(session: urlSession!)
        let expectation = XCTestExpectation(description: #function)
        let data = Data(endPointResponse.utf8)
        urlSession?.data = data
        let url = URL(fileURLWithPath: "http://www.google.com")
        httpManager?.get(url: url) { result in
            do {
                let decoder = JSONDecoder()
                switch result {
                case .failure:
                    XCTFail()
                case .success(let data):
                    let content = try! decoder.decode(EndPointModel.self, from: data)
                    let test: [String: String]? = ["data key":"data value"]
                    let expectedData = EndPointModel(status: "200", data: test )
                    XCTAssertEqual(content, expectedData)
                }
            }
            expectation.fulfill()
        }
    }
    
    func testSuccessfulDataResponse303(){
        urlSession = MockURLSession()
        urlSession?.setStatusCode(code: 303)
        httpManager = HTTPManager(session: urlSession!)
        let expectation = XCTestExpectation(description: #function)
        let data = Data(endPointResponse303.utf8)
        urlSession?.data = data
        let url = URL(fileURLWithPath: "http://www.google.com")
        httpManager?.get(url: url) { result in
            do {
                let decoder = JSONDecoder()
                switch result {
                case .failure:
                    XCTFail()
                case .success(let data):
                    let content = try! decoder.decode(EndPointModel.self, from: data)
                    let test: [String: String]? = ["data key":"data value"]
                    let expectedData = EndPointModel(status: "303", data: test )
                    XCTAssertEqual(content, expectedData)
                }
            }
            expectation.fulfill()
        }
    }
}
