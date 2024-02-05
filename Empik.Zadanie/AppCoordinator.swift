//
//  AppCoordinator.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController!
    var network: NetworkProtocol! = Network(service: AccuWeatherService())
    var initialData: Void!
    
    var parentCoordinator: (any Coordinator)?
    
    func start() {
        let searchCoordinator = CitiesSearchCoordinator()
        searchCoordinator.navigationController = navigationController
        searchCoordinator.network = network
               
        searchCoordinator.start()
    }
    
    func navigate(with data: Void) {}
}
