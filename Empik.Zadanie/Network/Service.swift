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

    private let session = URLSession.shared
    
    private func addKey(to url: URL) -> URL {
        url.appending(queryItems: [URLQueryItem(name: "apikey", value: apiKey)])
    }
    
    private func dataTask<Response: Decodable>(for url: URL) -> AnyPublisher<Response, ServiceError> {
        session.dataTaskPublisher(for: addKey(to: url))
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map { $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError { _ in
                ServiceError.common
            }
            .eraseToAnyPublisher()
    }
    
    func cityLookup(request: CitySearchRequest) -> AnyPublisher<CitiesResponse, ServiceError> {
        let url = URL(string: domain)!
            .appending(path: search)
            .appending(queryItems: [URLQueryItem(name: "q", value: request.query)])
        
        
        return dataTask(for: url)
    }
    
    
}
