//
//  WeatherCoordinator.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

enum WeatherCoordinatorDirection {
    case back
}

class WeatherCoordinator: Coordinator {
    var navigationController: UINavigationController!
    var network: NetworkProtocol!
    var initialData: String!
    
    func start() {
        guard let key = initialData else { return }
        
        let model = WeatherViewModel(key: key, network: network)
        let viewController = WeatherViewController(nibName: "WeatherViewController", bundle: nil)
        viewController.viewModel = model
        
        model.viewController = viewController
        
        navigationController.pushViewController(viewController, animated: true)
    }

    func navigate(with data: WeatherCoordinatorDirection) {
        switch data {
        case .back:
            navigationController.popViewController(animated: true)
        }
    }
}
