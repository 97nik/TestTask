//
//  AppDelegate.swift
//  TestTask
//
//  Created by Никита on 26.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       let mainVC = ViewController(presenter: CocktailPresenter())
 
        window = UIWindow(frame: UIScreen.main.bounds)
        UITabBar.appearance().tintColor = .systemGray
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
        return true
    }
}

