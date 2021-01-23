//
//  ViewController.swift
//  Project6 - Word Scramble
//
//  Created by Ahmed Nagy on 1/17/21.
//  Copyright © 2021 Ahmed Nagy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        startGame()
    }

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    // MARK: Implement the table view methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // this closure capture both the ac and the view controller and create a strong reference cycle with both of them but we don't want that nothing could ever be destroyed now so we mark them with weak
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [ weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowercasedAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowercasedAnswer) {
            if isOriginal(word: lowercasedAnswer) {
                if isReal(word: lowercasedAnswer) {
                    usedWords.insert(lowercasedAnswer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up"
                }
            } else {
                errorTitle = "Word already used"
                errorMessage = "Be more original!"
            }
        } else {
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title!.lowercased())"
        }
        
        showErrorMessage(title: errorTitle, message: errorMessage)
    }
    
    // Check if the word is made from the given letters
    func isPossible(word: String) -> Bool {
        
        guard var tempWord = title?.lowercased() else { return false }
        
        // "cease" can be made from "agencies"
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    // Check if the given word is already used
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    // Check if the word is actually a valid English word
    func isReal(word: String) -> Bool {
        if word.count < 3 || word == title! {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        
        ac.addAction(action)
        present(ac, animated: true)
    }
    
}

