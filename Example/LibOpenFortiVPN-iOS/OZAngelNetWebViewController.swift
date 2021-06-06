//
//  OZAngelNetWebViewController.swift
//  LibOpenFortiVPN-iOS_Example
//
//  Created by Henry Kim on 2021/06/06.
//  Copyright © 2021 neoroman. All rights reserved.
//

import UIKit
import WebKit

class OZAngelNetWebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "AngelNet"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        
        setupWebView()
    }
    
    @objc func doneButtonPressed() {
        self.dismiss(animated: true) { 
            //code
        }
    }
    
    private func setupWebView() {
        let urlString = "http://192.168.1.252:8000/home/login.htm"
        if let URL = URL(string: urlString) {
            let request = URLRequest(url: URL)
            self.webView.load(request)
        }
    }
}
