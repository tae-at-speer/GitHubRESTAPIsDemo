//
//  AppDelegate.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNC: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = MainViewController(nibName: "MainViewController", bundle: nil)
        mainNC = UINavigationController.init(rootViewController: mainVC)
        mainNC?.navigationBar.isHidden = true
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

