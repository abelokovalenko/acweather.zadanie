//
//  AWService.swift
//  ACWeather.Zadanie
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
        return self.url(url, byAppending: [
            URLQueryItem(name: "apikey", value: apiKey)
        ])
    }
    
    private func url(_ url: URL, byAppending queryItems: [URLQueryItem]) -> URL {
        if #available(iOS 16.0, *) {
            return url.appending(queryItems: queryItems)
        } else {
            let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems?.append(URLQueryItem(name: "apikey", value: apiKey))
            
            return components?.url ?? url
        }
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
        var url = URL(string: domain)!
        if #available(iOS 16.0, *) {
            url = url.appending(path: search)
                    .appending(queryItems: [URLQueryItem(name: "q", value: request.query)])
        } else {
            url = url.appendingPathComponent(search)
            url = self.url(url, byAppending: [URLQueryItem(name: "q", value: request.query)])
        }
        
        return dataTask(for: url)
    }
    
    func lookup(request: CitySearchRequest) -> AnyPublisher<CitiesResponse, ServiceError> {
        var url = URL(string: domain)!
        if #available(iOS 16.0, *) {
            url = url.appending(path: autocomplete)
                    .appending(queryItems: [URLQueryItem(name: "q", value: request.query)])
        } else {
            url = url.appendingPathComponent(search)
            url = self.url(url, byAppending: [URLQueryItem(name: "q", value: request.query)])
        }
        
        return dataTask(for: url)
    }

    func forecast(request: WeatherRequest) -> AnyPublisher<ForecastResponse, ServiceError> {
        var url = URL(string: domain)!
        if #available(iOS 16.0, *) {
            url = url.appending(path: forecasts)
                .appending(path: "\(request.key)")
        } else {
            url = url.appendingPathComponent(forecasts)
                .appendingPathComponent("\(request.key)")
        }
        
        return dataTask(for: url)
    }
    
    func weather(request: WeatherRequest) -> AnyPublisher<WeatherResponse, ServiceError> {
        var url = URL(string: domain)!
        if #available(iOS 16.0, *) {
            url = url.appending(path: weather)
                .appending(path: "\(request.key)")
                .appending(queryItems: [URLQueryItem(name: "details", value: "true")])

        } else {
            url = url.appendingPathComponent(weather)
                .appendingPathComponent("\(request.key)")
            url = self.url(url, byAppending: [URLQueryItem(name: "details", value: "true")])
        }
        
        return dataTask(for: url)
    }
}
