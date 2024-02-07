//
//  ViewModelProtocol.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

protocol ViewModelProtocol: AnyObject {
    var coordinator: (any CoordinatorProtocol)! { get set }
    var viewController: ViewControllerProtocol! { get set }
}
