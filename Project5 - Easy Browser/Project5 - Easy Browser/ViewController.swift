//
//  ViewController.swift
//  Project5 - Easy Browser
//
//  Created by Ahmed Nagy on 1/8/21.
//  Copyright © 2021 Ahmed Nagy. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UITableViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        title = "Web Pages"
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func openTapped() {
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        // this is why the handler method takes a UIAlertAction parameter telling you which action was selected
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        
        let myURLRequest = URLRequest(url: url)
        webView.load(myURLRequest)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        if let absString = url?.absoluteString {
            // Apple website has an about:blank being loaded for some reason...
            if absString == "about:blank" {
                decisionHandler(.allow)
                return
            }
        }
        
        let ac = UIAlertController(title: "This site is blocked", message: "You are not allowed to visit this site!" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
        
        decisionHandler(.cancel)
    }
    
    func setupWebView() {
        
        webView.navigationDelegate = self
        view = webView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // set up all needed buttons for the toolbar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let goBack = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [goBack, goForward, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    
    // MARK: TableView Controller Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        setupWebView()
        
        // make the request to load the first website in the websites array
        guard let url = URL(string: "https://" + websites[indexPath.row]) else {
            print("URL Not Valid")
            return
        }
        let myURLRequest = URLRequest(url: url)
        
        webView.load(myURLRequest)
        webView.allowsBackForwardNavigationGestures = true
    }
    
}

