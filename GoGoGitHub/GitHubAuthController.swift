//
//  GitHubAuthController.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/3/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

class GitHubAuthController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateLogin() {
        if let _ = UserDefaults.standard.getAccessToken() {
            self.loginButton.isEnabled = false
        } else {
            self.loginButton.isEnabled = true
        }
    }
    
    @IBAction func printTokenPressed(_ sender: Any) {
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let parameters = ["scope" : "email,user,repo"]
        
        GitHub.shared.oAuthRequestWith(parameters: parameters)
        
        updateLogin()
    }
    
    func dismissAuthController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
