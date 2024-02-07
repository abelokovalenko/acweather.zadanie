//
//  AppCoordinator.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController!
    var network: NetworkProtocol!
    var initialData: Void!
    
    var parentCoordinator: (any CoordinatorProtocol)?
    
    func start() {
        network = Network(service: service)
        
        let searchCoordinator = CitiesSearchCoordinator()
        searchCoordinator.navigationController = navigationController
        searchCoordinator.network = network
               
        searchCoordinator.start()
    }
    
    func navigate(to data: Void) {}
    
    private var service: ServiceProtocol {
        switch SettingsBundleHelper.source {
        case .demo:
            return DemoService()
        case .server:
            return AWService()
        }
    }
}
