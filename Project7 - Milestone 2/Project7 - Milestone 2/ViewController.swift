//
//  ViewController.swift
//  Project7 - Milestone 2
//
//  Created by Ahmed Nagy on 1/30/21.
//  Copyright © 2021 Ahmed Nagy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        // Creating BarButtonItems
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShoppingList))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearShoppingList))
        
        // Setting the BarButtonItems
        navigationItem.rightBarButtonItems = [addButton, shareButton]
        navigationItem.leftBarButtonItem = clearButton
        
    }
    
    // MARK:- Implementing TableView methods
    
    // How many rows to show
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    // What to show in each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }
    
    
    @objc func addItem() {
        
        let ac = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] (action) in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }
        
        ac.addAction(action)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    
    @objc func shareShoppingList() {
        
        let list = shoppingList.joined(separator: "\n")
        
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[1]
        
        present(vc, animated: true)
    }
    
    @objc func clearShoppingList() {
        
        let ac = UIAlertController(title: "Do you want to delete your shopping list?", message: "This will clear your shopping list. Are you sure?", preferredStyle: .alert)
        let action = UIAlertAction(title: "I'm sure", style: .default) { [weak self](action) in
            self?.shoppingList.removeAll()
            self?.tableView.reloadData()
        }
        
        ac.addAction(action)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    func submit(_ item: String) {
        if item.isEmpty {
            showErrorMessage(title: "Item cannot be empty", message: "Try typing something!")
        } else {
            shoppingList.insert(item, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func showErrorMessage(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        ac.addAction(action)
        present(ac, animated: true)
    }
}

