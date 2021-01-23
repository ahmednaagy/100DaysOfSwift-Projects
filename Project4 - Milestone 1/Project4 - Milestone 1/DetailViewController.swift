//
//  DetailViewController.swift
//  Project4 - Milestone 1
//
//  Created by Ahmed Nagy on 1/6/21.
//  Copyright © 2021 Ahmed Nagy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pictures"
        navigationItem.largeTitleDisplayMode = .never

        if selectedImage != nil {
            imageView.image = UIImage(named: selectedImage!)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
    
    
    @objc func shareTapped() {
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.9), let imageName = selectedImage else {
            print("No image found")
            return
        }
        let activityVC = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityVC, animated: true)
    }

}
