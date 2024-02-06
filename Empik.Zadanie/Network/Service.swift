//
//  Service.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation
import Combine

class AccuWeatherService: ServiceProtocol {
    private let apiKey = "4ejkwJ51n2KOrQZk4KgklJ7ndfCVJDWn"
    private let domain = "https://dataservice.accuweather.com"
    private let autocomplete = "/locations/v1/cities/autocomplete"
    private let search = "locations/v1/cities/search"
    private let weather = "currentconditions/v1"

    private let session = URLSession.shared
    
    private func globalQuery(from url: URL) -> URL {
        url.appending(queryItems: [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "language", value: Locale.current.identifier)
        ])
    }
    
    private func dataTask<Response: Decodable>(for url: URL) -> AnyPublisher<Response, ServiceError> {
        session.dataTaskPublisher(for: globalQuery(from: url))
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map { $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError { _ in ServiceError.common }
            .eraseToAnyPublisher()
    }
    
    func searchCity(request: CitySearchRequest) -> AnyPublisher<CitiesResponse, ServiceError> {
        let url = URL(string: domain)!
            .appending(path: search)
            .appending(queryItems: [URLQueryItem(name: "q", value: request.query)])
        
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
