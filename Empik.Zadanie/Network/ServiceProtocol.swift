//
//  ServiceProtocol.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation
import Combine

protocol ServiceProtocol {
    func searchCity(request: CitySearchRequest) -> AnyPublisher<CitiesResponse, ServiceError>
    func lookup(request: CitySearchRequest) -> AnyPublisher<CitiesResponse, ServiceError>
    func weather(request: WeatherRequest) -> AnyPublisher<WeatherResponse, ServiceError>
    func forecast(request: WeatherRequest) -> AnyPublisher<ForecastResponse, ServiceError>
}
