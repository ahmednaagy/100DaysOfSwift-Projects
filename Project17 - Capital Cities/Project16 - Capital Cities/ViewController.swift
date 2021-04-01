//
//  ViewController.swift
//  Project16 - Capital Cities
//
//  Created by Ahmed Nagy on 01/04/2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    let mapTypes = ["hybrid": MKMapType.hybrid, "hybridFlyover": MKMapType.hybridFlyover, "mutedStandard": MKMapType.mutedStandard, "satellite": MKMapType.satellite, "satelliteFlyover": MKMapType.satelliteFlyover, "standard": MKMapType.standard]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeStyle))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics", wiki: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", wiki: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8546, longitude: 2.3508), info: "Often called the City of Light", wiki: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", wiki: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself", wiki: "https://en.wikipedia.org/wiki/Washington_(state)")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        // If it isn't able to find a reusable view, create a new one
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.pinTintColor = UIColor(red: 23/255, green: 76/255, blue: 200/255, alpha: 1)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            
        } else {
            annotationView?.annotation = annotation
        }
   
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }

        if let vc = storyboard?.instantiateViewController(identifier: "webView") as? webViewController {
            vc.placeWiki = capital.wiki
            vc.placeName = capital.title
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func changeStyle() {
        let ac = UIAlertController(title: "Change Map Style", message: "Change the map Style to satellite?", preferredStyle: .alert)
        
        for style in mapTypes.keys {
            ac.addAction(UIAlertAction(title: style, style: .default, handler: typeSelected))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)
    }
    
    func typeSelected(action: UIAlertAction) {
        guard let title = action.title else { return }
        
        if let mapType = mapTypes[title] {
            mapView.mapType = mapType
        }
    }
    
}

