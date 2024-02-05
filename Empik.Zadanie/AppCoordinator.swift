//
//  AppCoordinator.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = CitiesSearchViewController(nibName: "CitiesSearchViewController",
                                                              bundle: nil)

        let searchViewModel = CitiesSearchViewModel(network: Network(service: AccuWeatherService()))
        searchViewModel.coordinator = CitiesSearchCoordinator(navigationController: navigationController)
        searchViewModel.viewController = searchViewController

        searchViewController.viewModel = searchViewModel
       
        navigationController.pushViewController(searchViewController, animated: true)
    }
}
