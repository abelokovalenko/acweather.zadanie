//
//  ViewModel.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

protocol ViewModel: AnyObject {
    var coordinator: (any Coordinator)? { get set }
    var viewController: UIViewController! { get set }
}
