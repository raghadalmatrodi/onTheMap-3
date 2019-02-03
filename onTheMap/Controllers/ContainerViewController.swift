//
//  ContainerViewController.swift
//  onTheMap
//
//  Created by Raghad Almatrodi on 1/19/19.
//  Copyright © 2019 raghad almatrodi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ContainerViewController: UIViewController {
    
    var locationsData: LocationsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadStudentLocations()
    }
    
    func setupUI() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocationTapped(_:)))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshLocationsTapped(_:)))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout(_:)))
        
        navigationItem.rightBarButtonItems = [plusButton, refreshButton]
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc private func addLocationTapped(_ sender: Any) {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationNavigationController") as! AddLocationViewController
        let navigaitonController = UINavigationController(rootViewController: navController)
        present(navigaitonController, animated: true, completion: nil)
    }
    
    @objc private func refreshLocationsTapped(_ sender: Any) {
        loadStudentLocations()
    }
    
    
    
    
    
 @objc func logout(_ sender: Any) {
        API.Parser.logout { (error) in
           
            
            API.Parser.logout() { error in
                guard error == ""  else {

                    return
                }
                DispatchQueue.main.async {
                    UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
                    
                    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = loginVC
                
                    
                }
            }
            
            
        }
      
        
    }
 
    
    private func loadStudentLocations() {
        API.Parser.getStudentLocations { (data) in
            guard let data = data else {
                self.showAlert(title: "Error", message: "No internet connection found")
                return
            }
            guard data.studentLocations.count > 0 else {
                self.showAlert(title: "Error", message: "No pins found")
                return
            }
            self.locationsData = data
        }
    }
    func postStudentLocation(info: UserInfo, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let paramHeaders = [
            APIConstants.HeaderKeys.PARSE_API_KEY       : APIConstants.HeaderKeys.PARSE_API_KEY,
            APIConstants.HeaderKeys.PARSE_APP_ID: APIConstants.HeaderKeys.PARSE_APP_ID,
            ] as [String: AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(StudentLocation().uniqueKey)\", \"firstName\": \"\(StudentLocation().firstName)\", \"lastName\": \"\(StudentLocation().lastName)\",\"mapString\": \"\(StudentLocation().mapString)\", \"mediaURL\": \"\(StudentLocation().mediaURL)\",\"latitude\": \(StudentLocation().latitude), \"longitude\": \(StudentLocation().longitude)}"
   
    }}
