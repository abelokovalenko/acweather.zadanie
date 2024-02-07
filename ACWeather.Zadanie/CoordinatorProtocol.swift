//
//  CoordinatorProtocol.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    associatedtype InitialData
    associatedtype Navigation
    
    var navigationController: UINavigationController! { get set }
    var network: NetworkProtocol! { get set }
    var initialData: InitialData! { get set }
    
    func navigate(to : Navigation)
    func start()
}
