//
//  ServiceError.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 07/02/2024.
//

import Foundation

enum ServiceError: Error {
    case domain(AWError)
    case common(String)
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .domain(let awError):
            return awError.message
        case .common(let text):
            return text
        }
    }
}
