//
//  Network.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation
import Combine

class Network: NetworkProtocol {
    let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    func searchCity(request: String) -> AnyPublisher<[City], NetworkError> {
        let request = CitySearchRequest(query: request)
        return service.searchCity(request: request)
            .mapError { _ in NetworkError.common }
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    func weather(key: String) -> AnyPublisher<Weather, NetworkError> {
        let request = WeatherRequest(key: key)
        return service.weather(request: request)
            .tryMap { $0.first! }
            .mapError { _ in NetworkError.common }
            .eraseToAnyPublisher()
    }
}
