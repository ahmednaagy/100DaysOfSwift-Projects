//
//  Petition.swift
//  Project8 - Whitehouse Petitions
//
//  Created by Ahmed Nagy on 2/2/21.
//  Copyright © 2021 Ahmed Nagy. All rights reserved.
//

import Foundation


struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
