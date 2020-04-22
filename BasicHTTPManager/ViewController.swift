//
//  ViewController.swift
//  BasicHTTPManager
//
//  Created by Steven Curtis on 05/03/2020.
//  Copyright © 2020 Steven Curtis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData(HTTPManager(session: URLSession.shared), completion: {response in
            // perform an action with the response
            print (response)
        })
    }
    
    func downloadData<T: HTTPManagerProtocol>(_ httpManager: T, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: "https://docs.google.com/uc?export=download&id=0Bz-w5tutuZIYeDU0VDRFWG9IVUE") {
            httpManager.get(url: url, completionBlock: {data in
                completion(data)
            })
        }
    }
    
}
