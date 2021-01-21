//
//  DetailViewController.swift
//  Project1-StormViewer
//
//  Created by Ahmed Nagy on 12/24/20.
//  Copyright © 2020 Ahmed Nagy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var totalNumberOfImages: Int?
    var currentSelectedPosition: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if totalNumberOfImages != nil && currentSelectedPosition != nil {
            title = "Picture \(currentSelectedPosition! + 1) of \(totalNumberOfImages!)"
        }
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.hidesBarsOnTap = false
    }

}
