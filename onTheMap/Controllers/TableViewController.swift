//
//  TableViewController.swift
//  onTheMap
//
//  Created by Raghad Almatrodi on 1/19/19.
//  Copyright © 2019 raghad almatrodi. All rights reserved.
//

import UIKit

class TableViewController: ContainerViewController {
    
    @IBOutlet weak var tableView: UITableView!
  
    
    override var locationsData: LocationsData? {
        didSet {
            guard let locationsData = locationsData else { return }
            locations = locationsData.studentLocations
        }
    }
    var locations: [StudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}


extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let location = locations[indexPath.row]
        cell.textLabel?.text = location.mapString
        cell.detailTextLabel?.text = location.mediaURL
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loc = locations[indexPath.row]
        if let url = URL(string: loc.mediaURL!),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}

