//
//  ViewController.swift
//  Project2-GuessTheFlag
//
//  Created by Ahmed Nagy on 12/26/20.
//  Copyright © 2020 Ahmed Nagy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numberOfQuestion = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(shareTapped))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "\(countries[correctAnswer].uppercased()) \(score)"
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        numberOfQuestion += 1
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        if numberOfQuestion >= 10 {
            finalAlert()
            return
        }
        
        if title == "Correct" {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default, handler: askQuestion)
            
            ac.addAction(action)
            present(ac, animated: true)
            
        } else {
            let ac = UIAlertController(title: title, message: "Wrong! That's he flag of \(countries[sender.tag].uppercased()) Your score is \(score)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default, handler: askQuestion)
            
            ac.addAction(action)
            present(ac, animated: true)
        }
        
    }
    
    func finalAlert() {
        
        let ac = UIAlertController(title: "Summary", message: "You have scored \(score) points out of 10", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: resetScore)
        
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func resetScore(action: UIAlertAction! = nil) {
        score = 0
        numberOfQuestion = 0
        askQuestion()
    }
    
    @objc func shareTapped() {
        let message = "You scored \(score) points"
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
}

