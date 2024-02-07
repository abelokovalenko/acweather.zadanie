//
//  Collection.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 06/02/2024.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
