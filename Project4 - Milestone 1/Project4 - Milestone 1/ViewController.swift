//
//  ViewController.swift
//  Project4 - Milestone 1
//
//  Created by Ahmed Nagy on 1/6/21.
//  Copyright © 2021 Ahmed Nagy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FlagViewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        
        // Extract the images from the app bundle
        for item in items {
            if item.hasSuffix("@3x.png") {
                pictures.append(item)
            }
        }
    }
    
    
    // MARK: - Override the tableview methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    
    // What to show in each row?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        if pictures[indexPath.row].hasSuffix("@3x.png") {
            let flagName = pictures[indexPath.row].replacingOccurrences(of: "@3x.png", with: "")
            if flagName.hasPrefix("u") {
                cell.textLabel?.text = flagName.uppercased()
            } else {
                cell.textLabel?.text = flagName.capitalized
            }
            
        }
        
        return cell
    }
    
    // What to show when a row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            // success! set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            
            // push it into the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    
}

