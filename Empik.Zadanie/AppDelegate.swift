//
//  AppDelegate.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationCon = UINavigationController.init()
        appCoordinator = AppCoordinator(navigationController: navigationCon)
        appCoordinator!.start()
        window!.rootViewController = navigationCon
        window!.makeKeyAndVisible()
        
        return true
    }
}

