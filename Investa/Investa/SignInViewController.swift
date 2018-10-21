//
//  SignInViewController.swift
//  Investa
//
//  Created by Nicholas Grana on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        if let shared = GIDSignIn.sharedInstance() {
//            if shared.hasAuthInKeychain() {
//                GIDSignIn.sharedInstance()?.signInSilently()
//            } else {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let viewController = storyboard.instantiateViewController(withIdentifier: "Login")
//                present(viewController, animated: false, completion: nil)
//            }
//        }
    }
    
}

