//
//  WeatherCoordinator.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

enum WeatherCoordinatorNavigation {
    case back
}

class WeatherCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController!
    var network: NetworkProtocol!
    var initialData: City!
    
    func start() {
        guard let city = initialData else { return }
        
        let model = WeatherViewModel(city: city, network: network)
        let viewController = WeatherViewController(nibName: "WeatherViewController", bundle: nil)
        viewController.viewModel = model
        
        model.viewController = viewController
        
        navigationController.pushViewController(viewController, animated: true)
    }

    func navigate(to data: WeatherCoordinatorNavigation) {
        switch data {
        case .back:
            navigationController.popViewController(animated: true)
        }
    }
}
