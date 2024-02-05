//
//  CitiesSearchCoordinator.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

class CitiesSearchCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController

    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        
    }
    
    var id: String!
}
