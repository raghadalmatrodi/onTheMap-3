//
//  ConfirmLocationViewController.swift
//  onTheMap
//
//  Created by Raghad Almatrodi on 1/19/19.
//  Copyright © 2019 raghad almatrodi. All rights reserved.
//

/*import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
   
    
    var location: StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupMap()
    }
    
    @IBAction func finishTapped(_ sender: UIButton) {
       
        API.Parser.postLocation(location: self.location!){ status  in
            guard status else {
                self.showAlert(title: "Error", message: String(status))
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    private func setupMap() {
        guard let location = location else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
       
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
}

extension ConfirmLocationViewController: MKMapViewDelegate {
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
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loc = locations[indexPath.row]
        if let url = URL(string: loc.mediaURL!),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let loc =MKAnnotationView
        if let url = URL(string: loc.mediaURL!),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
}*/
}
*/
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var errorLabel: UILabel!
   
    var location: StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
    }
    
    @IBAction func finishTapped(_ sender: UIButton) {
        
        API.Parser.postLocation(location: self.location!) { created  in
            guard created == true else {
                self.errorLabel.text = "error"
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    private func setupMap() {
        guard let location = location else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
}

extension ConfirmLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view!.canShowCallout = true
            view!.pinTintColor = .red
            view!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            view!.annotation = annotation
        }
        
        return view
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
