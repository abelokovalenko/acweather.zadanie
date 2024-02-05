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
    var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController.init()
        appCoordinator = AppCoordinator()
        appCoordinator.navigationController = navigationController
        appCoordinator.start()
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }
}

