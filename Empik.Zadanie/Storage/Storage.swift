//
//  Storage.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 06/02/2024.
//

import Foundation

protocol Storage: CitiesSourceProtocol {
    func append(city: City)
    func delete(city: City)
}
