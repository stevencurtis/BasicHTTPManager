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
        // for further configuration use URLSession(configuration: URLSessionConfiguration.default)
        let urlsession = URLSession.shared
        
        // instantiate the HTTPManager
        let httpManager = HTTPManager(session: urlsession)
        
        if let url = URL(string: "https://docs.google.com/uc?export=download&id=0Bz-w5tutuZIYeDU0VDRFWG9IVUE") {
            httpManager.get(url: url, completionBlock: {result in
                print (result)
            })
        }
    }
}

