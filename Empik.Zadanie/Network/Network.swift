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
    
    func searchCity(request: String) -> AnyPublisher<[AWCity], NetworkError> {
        let request = CitySearchRequest(query: request)
        return service.searchCity(request: request)
            .mapError { .service($0) }
            .eraseToAnyPublisher()
    }
    
    func lookup(request: String) -> AnyPublisher<[AWCity], NetworkError> {
        let request = CitySearchRequest(query: request)
        return service.lookup(request: request)
            .mapError { .service($0) }
            .eraseToAnyPublisher()
    }

    func weather(key: String) -> AnyPublisher<Weather, NetworkError> {
        let request = WeatherRequest(key: key)
        return service.weather(request: request)
            .tryMap { $0.first! }
            .mapError { error in
                if let serviceError = error as? ServiceError {
                    return .service(serviceError)
                }
                
                return .common(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    func forecast(key: String) -> AnyPublisher<[Forecast], NetworkError> {
        let request = WeatherRequest(key: key)
        return service.forecast(request: request)
            .mapError { .service($0) }
            .eraseToAnyPublisher()
    }
}
