//
//  ServiceProtocol.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation
import Combine

enum ServiceError: Error {
    case common
}

protocol ServiceProtocol {
    func searchCity(request: CitySearchRequest) -> AnyPublisher<CitiesResponse, ServiceError>
    func weather(request: WeatherRequest) -> AnyPublisher<WeatherResponse, ServiceError>
}
