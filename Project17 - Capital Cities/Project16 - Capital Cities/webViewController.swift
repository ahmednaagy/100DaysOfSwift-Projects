//
//  webViewController.swift
//  Project16 - Capital Cities
//
//  Created by Ahmed Nagy on 01/04/2021.
//

import UIKit
import WebKit
class webViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    
    var placeWiki: String!
    var placeName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let placeWiki = placeWiki else { return }
        guard let placeName = placeName else { return }
        
        title = placeName
        
        guard let url = URL(string: placeWiki) else { return }
        webView.load(URLRequest(url: url))
    }


}
