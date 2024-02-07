//
//  StoredCity.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 06/02/2024.
//

import Foundation
import CoreData

extension StoredCity {
    func touch() {
        self.date_displayed = Date()
    }
}
