//
//  ViewController.swift
//  Project12 - Testing
//
//  Created by Ahmed Nagy on 10/03/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        defaults.setValue(23, forKey: "age")
        defaults.setValue(true, forKey: "useFaceID")
        defaults.setValue(CGFloat.pi, forKey: "pi")
        
        defaults.setValue("Ahmed Nagy", forKey: "name")
        defaults.setValue(Date(), forKey: "lastRun")
        
        let array = ["hello", "world"]
        defaults.setValue(array, forKey: "savedArray")
        
        let dict = ["name": "Ahmed", "lastName": "Nagy"]
        defaults.setValue(dict, forKey: "savedDictionary")
        
        
        let savedInteger = defaults.integer(forKey: "age")
        let savedBool = defaults.bool(forKey: "useFaceID")
        
        let savedArray = defaults.object(forKey: "savedArray") as? [String] ?? [String]()
        let savedDitionary = defaults.object(forKey: "savedDictionary") as? [String: String] ?? [String: String]()
        
    }


}

