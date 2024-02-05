//
//  CitiesSearchCoordinator.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

enum CitiesSearchCoordinatorNavigation {
    case weather(String)
}

class CitiesSearchCoordinator: Coordinator {
    
    var network: NetworkProtocol!
    var navigationController: UINavigationController!
    var initialData: Void!
    
    func start() {
        let searchViewModel = CitiesSearchViewModel(network: network)
        searchViewModel.coordinator = self

        let searchViewController = CitiesSearchViewController(nibName: "CitiesSearchViewController",
                                                              bundle: nil)
        searchViewController.viewModel = searchViewModel

        searchViewModel.viewController = searchViewController

        navigationController.pushViewController(searchViewController, animated: true)
    }

    func navigate(with data: CitiesSearchCoordinatorNavigation) {
        if case let .weather(key) = data {
            let weatherCoordinator = WeatherCoordinator()
            weatherCoordinator.network = network
            weatherCoordinator.navigationController = navigationController
            weatherCoordinator.initialData = key
            
            weatherCoordinator.start()
        }
    }
}
