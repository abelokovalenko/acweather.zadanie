//
//  CitiesSearchCoordinator.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

enum CitiesSearchCoordinatorNavigation {
    case weather(City)
}

class CitiesSearchCoordinator: CoordinatorProtocol {
    
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

    func navigate(to navigation: CitiesSearchCoordinatorNavigation) {
        if case let .weather(city) = navigation {
            let weatherCoordinator = WeatherCoordinator()
            weatherCoordinator.network = network
            weatherCoordinator.navigationController = navigationController
            weatherCoordinator.initialData = city
            
            weatherCoordinator.start()
        }
    }
}
