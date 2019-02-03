//
//  AddLocationViewController.swift
//  onTheMap
//
//  Created by Raghad Almatrodi on 1/19/19.
//  Copyright © 2019 raghad almatrodi. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var mediaLinkTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotificationsObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotificationsObserver()
    }
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        guard let location = locationTextField.text,
            let mediaLink = mediaLinkTextField.text,
            location != "", mediaLink != "" else {
                self.showAlert(title: "Missing information", message: "Please fill both fields and try again")
                return
        }
        
        let studentLocation = StudentLocation(mapString: location, mediaURL: mediaLink)
        geocodeCoordinates(studentLocation)
        
    }
    
    private func geocodeCoordinates(_ studentLocation: StudentLocation) {
        
        let ai = self.startAnActivityIndicator()
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, err) in
            
            ai.stopAnimating()
            guard let firstLocation = placeMarks?.first?.location else {
                self.showAlert(title: "Error", message: "There are no location with specified coordinates")
                return }
            var location = studentLocation
            location.latitude = firstLocation.coordinate.latitude
            location.longitude = firstLocation.coordinate.longitude
            self.performSegue(withIdentifier: "mapSegue", sender: location)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue", let vc = segue.destination as? ConfirmLocationViewController {
            vc.location = (sender as! StudentLocation)
        }
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelTapped(_:)))
        
        locationTextField.delegate = self
        mediaLinkTextField.delegate = self
    }
    
    @objc private func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


