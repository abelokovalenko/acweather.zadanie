//
//  CitiesSourceProtocol.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 07/02/2024.
//

import Foundation

protocol CitiesSourceProtocol {
    var count: Int { get }
    func city(at: Int) -> City?
}
