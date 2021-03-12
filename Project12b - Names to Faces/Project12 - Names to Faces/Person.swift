//
//  Person.swift
//  Project12 - Names to Faces
//
//  Created by Ahmed Nagy on 28/02/2021.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
