//
//  MapViewController.swift
//  onTheMap
//
//  Created by Raghad Almatrodi on 1/19/19.
//  Copyright © 2019 raghad almatrodi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: ContainerViewController, MKMapViewDelegate {
    
   //to initialize the variables
    @IBOutlet weak var mapView: MKMapView!
   
    
    override var locationsData: LocationsData? {
        didSet {
            updatePins()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    func updatePins() {
        guard let locations = locationsData?.studentLocations else { return }
        
        
        var annotations = [MKPointAnnotation]()
        
       
        for location in locations {
            
           
            guard let latitude = location.latitude, let longitude = location.longitude else { continue }
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "") \(last ?? "")"
            annotation.subtitle = mediaURL
           
           
            annotations.append(annotation)
        }
        
    
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
           
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
   
    
    
    
}
