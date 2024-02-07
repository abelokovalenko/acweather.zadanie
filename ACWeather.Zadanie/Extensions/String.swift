//
//  String.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
