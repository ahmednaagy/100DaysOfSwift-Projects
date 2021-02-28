//
//  ViewController.swift
//  Project8 - Whitehouse Petitions
//
//  Created by Ahmed Nagy on 2/1/21.
//  Copyright © 2021 Ahmed Nagy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Whitehouse Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(askFilter))
        let reset = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetFilter))
        reset.tintColor = .red
        reset.isEnabled = false
        
        navigationItem.leftBarButtonItems = [filter, reset]
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    
    @objc func fetchJSON() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse!
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed please check your connection and try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    // Parse the data we are getting from the url
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: """
All the data comes from the "We The People API" of the Whitehouse
""", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    @objc func askFilter() {
        let ac = UIAlertController(title: "Filter", message: "Filter the petitions on the following keyword", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let filterAction = UIAlertAction(title: "Filter", style: .default) { [ weak ac, weak self ](action) in
            guard let keyWord = ac?.textFields?[0].text else { return }
            DispatchQueue.global().async {
                self?.filter(keyWord)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        ac.addAction(filterAction)
        present(ac, animated: true)
    }
    
    
    @objc func resetFilter() {
        filteredPetitions.removeAll()
        navigationItem.leftBarButtonItems?.last?.isEnabled = false
        tableView.reloadData()
    }
    
    @objc func filter(_ keyWord: String) {
        
        if keyWord.isEmpty {
            filteredPetitions = petitions
        } else {
            for petition in petitions {
                if petition.title.lowercased().contains(keyWord.lowercased()) || petition.body.lowercased().contains(keyWord.lowercased()) {
                    filteredPetitions.append(petition)
                }
            }
        }
        
        navigationItem.leftBarButtonItems?.last?.isEnabled = true
        tableView.reloadData()
    }
    
    // MARK:- Implementing TableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.isEmpty ? petitions.count : filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition : Petition
        
        if filteredPetitions.isEmpty {
            petition = petitions[indexPath.row]
        } else {
            petition = filteredPetitions[indexPath.row]
        }
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if filteredPetitions.isEmpty {
            vc.detailItem = petitions[indexPath.row]
        } else {
            vc.detailItem = filteredPetitions[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


