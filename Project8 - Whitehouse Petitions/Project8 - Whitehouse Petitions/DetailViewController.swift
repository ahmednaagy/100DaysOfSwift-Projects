//
//  DetailViewController.swift
//  Project8 - Whitehouse Petitions
//
//  Created by Ahmed Nagy on 2/3/21.
//  Copyright © 2021 Ahmed Nagy. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; font-family: Helvetica} </style>
        </head>
        <body>
        \(detailItem.title)
        <br><br>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
        
    }


}
