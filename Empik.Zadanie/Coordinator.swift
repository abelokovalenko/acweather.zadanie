//
//  Coordinator.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}
