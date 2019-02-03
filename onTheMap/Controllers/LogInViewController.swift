//
//  LogInViewController.swift
//  onTheMap
//
//  Created by Raghad Almatrodi on 1/19/19.
//  Copyright © 2019 raghad almatrodi. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
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
    
    private func setupUI() {
        email.delegate = self
        password.delegate = self
    }
    
   
    
   
    @IBAction func logIn(_ sender: UIButton) {
        
        
        if email.text!.isEmpty || password.text!.isEmpty {
            self.showAlert(title: "Error", message: ("Please enter e-mail and password"))
            
        }
        if !email.text!.isEmpty && !password.text!.isEmpty {
            API.postSession(username: email.text!, password: password.text!) { (errString) in
                guard errString == nil else {
                    self.showAlert(title: "Error", message: errString!)
                    return
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Login", sender: nil)
                }
                
            }
        }
    }
    
}

extension UIViewController {
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.keyboardwillshow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.keyboardwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardwillshow (_ notification:Notification){
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardwillHide(_ notification:Notification){
        
        self.view.frame.origin.y = 0
        
    }
 
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
        super.touchesBegan(touches, with: event)
    }
    
    
}


 
   



