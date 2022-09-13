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
        
        //Init UserDefaultHelper value
        initUserDefaultValue()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainVC = UserListViewController.init(user: nil, type: .none)
        mainNC = UINavigationController.init(rootViewController: mainVC)
        mainNC?.navigationBar.isHidden = true
        
        window?.rootViewController = mainNC;
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func initUserDefaultValue()
    {
        //Server Url
        if UserDefaultHelper.standard.getData(type: String.self, forKey:.serverUrl) == nil
        {
            UserDefaultHelper.standard.setData(value: "https://api.github.com/", key: .serverUrl)
        }
        
        //Localization
        if UserDefaultHelper.standard.getData(type: String.self, forKey:.localization) == nil
        {
            UserDefaultHelper.standard.setData(value: "en", key: .localization)
        }
        
        //Per_page
        if UserDefaultHelper.standard.getData(type: String.self, forKey:.searchPerPage) == nil
        {
            UserDefaultHelper.standard.setData(value: "100", key: .searchPerPage)
        }
        
        
    }
}

