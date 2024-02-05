//
//  Coordinator.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

protocol Coordinator {
    associatedtype InitialData
    associatedtype NavigationData
    
    var navigationController: UINavigationController! { get set }
    var network: NetworkProtocol! { get set }
    var initialData: InitialData! { get set }
    
    func navigate(with data: NavigationData)
    func start()
}
