//
//  AWService.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation
import Combine

class AWService: ServiceProtocol {
    private let apiKey = "4ejkwJ51n2KOrQZk4KgklJ7ndfCVJDWn"
    private let domain = "https://dataservice.accuweather.com"
    private let autocomplete = "/locations/v1/cities/autocomplete"
    private let search = "locations/v1/cities/search"
    private let weather = "currentconditions/v1"
    private let forecasts = "forecasts/v1/hourly/12hour"

    private let session = URLSession.shared
    
    private func globalQuery(from url: URL) -> URL {
        url.appending(queryItems: [
            URLQueryItem(name: "apikey", value: apiKey)
        ])
    }
    
    private func dataTask<Response: Decodable>(for url: URL) -> AnyPublisher<Response, ServiceError> {
        session.dataTaskPublisher(for: globalQuery(from: url))
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap {
                let data = $0.data
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(Response.self, from: data)
                    return response
                } catch {
                    let awerror = try JSONDecoder().decode(AWError.self, from: data)
                    throw ServiceError.domain(awerror)
                }
            }
            .mapError { error in
                return error as? ServiceError ?? ServiceError.common(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    func searchCity(request: CitySearchRequest) -> AnyPublisher<CitiesResponse, ServiceError> {
        let url = URL(string: domain)!
            .appending(path: search)
            .appending(queryItems: [URLQueryItem(name: "q", value: request.query)])
        
        return dataTask(for: url)
    }
    
    func lookup(request: CitySearchRequest) -> AnyPublisher<CitiesResponse, ServiceError> {
        let url = URL(string: domain)!
            .appending(path: autocomplete)
            .appending(queryItems: [URLQueryItem(name: "q", value: request.query)])
        
        return dataTask(for: url)
    }

    func forecast(request: WeatherRequest) -> AnyPublisher<ForecastResponse, ServiceError> {
        let url = URL(string: domain)!
            .appending(path: forecasts)
            .appending(path: "\(request.key)")

        return dataTask(for: url)
    }
    
    func weather(request: WeatherRequest) -> AnyPublisher<WeatherResponse, ServiceError> {
        let url = URL(string: domain)!
            .appending(path: weather)
            .appending(path: "\(request.key)")
            .appending(queryItems: [URLQueryItem(name: "details", value: "true")])
        
        return dataTask(for: url)
    }
}
