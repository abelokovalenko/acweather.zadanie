//
//  DemoService.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation
import Combine

class DemoService: ServiceProtocol {
    func searchCity(request: CitySearchRequest) -> AnyPublisher<CitiesResponse, ServiceError> {
        demoData(filename: "search")
    }
    
    func weather(request: WeatherRequest) -> AnyPublisher<WeatherResponse, ServiceError> {
        demoData(filename: "weather")
    }
    
 
    private func demoData<T: Decodable>(filename: String) -> AnyPublisher<T, ServiceError> {
        do {
            let jsonPath = Bundle.main.path(forResource: filename, ofType: "json")
            let jsonString = try String(contentsOfFile: jsonPath!)
            let jsonData = jsonString.data(using: .utf8)!
            let response = try JSONDecoder().decode(T.self, from: jsonData)
            return Just(response)
                .setFailureType(to: ServiceError.self)
                .delay(for: 0.5, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: ServiceError.common)
                .delay(for: 0.5, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }

}
