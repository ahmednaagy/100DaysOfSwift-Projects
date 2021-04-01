//
//  Capital.swift
//  Project16 - Capital Cities
//
//  Created by Ahmed Nagy on 01/04/2021.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String
    var wiki: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, wiki: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.wiki = wiki
    }
    
    // With map annotations, you can't use structs, and you must inherit from NSObject because it needs to be interactive with Apple's Objective-C code.

    /*
    An object that adopts this protocol manages the data that you want to display on the map surface. It does not provide the visual representation displayed by the map. Instead, your map view's delegate provides the MKAnnotationView objects needed to display the content of your annotations. When you want to display content at a specific point on the map, add an annotation object to the map view.
     */

}
