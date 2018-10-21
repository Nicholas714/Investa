//
//  LoginViewController.swift
//  Investa
//
//  Created by Tillson Galloway on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        if usernameField.text != "" && passwordField.text != "" {
            APIManager.shared.login(username: usernameField.text!, password: passwordField.text!, onSuccess: { (success) in
                // eh it's a hackathon so why not
                UserDefaults.standard.set(self.usernameField.text!, forKey: "username")
                UserDefaults.standard.set(self.passwordField.text!, forKey: "password")
                APIManager.shared.getCurrentUser(onSuccess: { (user) in
                    APIManager.shared.user = user
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "Portfolio")
                    self.present(controller, animated: true, completion: nil)
                }, onFailure: { (error) in
                    print(error)
                })
            }) { (error) in
                print(error)
            }
        }
    }
    
}
