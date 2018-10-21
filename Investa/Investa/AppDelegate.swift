//
//  AppDelegate.swift
//  Investa
//
//  Created by Nicholas Grana on 10/19/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let username = UserDefaults.standard.string(forKey: "username")
        let password = UserDefaults.standard.string(forKey: "password")
        if username != nil && password != nil {
            APIManager.shared.login(username: username!, password: password!, onSuccess: { (success) in
                print(1)
                if !success {
                    APIManager.shared.token = nil
                    return
                }
                APIManager.shared.getCurrentUser(onSuccess: { (user) in
                    print("USER LOGGED IN")
                    APIManager.shared.user = user
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "Portfolio")
                    self.window!.rootViewController = controller
                }, onFailure: { (error) in
                    print(error)
                    APIManager.shared.token = nil
                })
            }) { (error) in
                print(error)
                APIManager.shared.token = nil
            }
        }
        
//        let user = User(name: "User", portfolioValue: 25000)
//        let apple = Stock(name: "Apple", symbol: "APPL", currentPrice: 1000, initialBuyPrice: 500)
//        let stocks = [apple, apple, apple, apple]
//        
//        user.ownedStocks = stocks
//        APIManager.shared.user = user
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "Portfolio")
//        if let presented = self.window?.rootViewController?.presentedViewController {
//            presented.dismiss(animated: false, completion: {
//                self.window?.rootViewController?.present(viewController, animated: false, completion: nil)
//            })
//        } else {
//            window?.rootViewController?.present(viewController, animated: false, completion: nil)
//        }
//        
        return true
    }
    

}

