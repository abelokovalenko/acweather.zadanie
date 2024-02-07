//
//  NetworkProtocol.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func searchCity(request: String) -> AnyPublisher<[AWCity], NetworkError>
    func lookup(request: String) -> AnyPublisher<[AWCity], NetworkError>
    func weather(key: String) -> AnyPublisher<Weather, NetworkError>
    func forecast(key: String) -> AnyPublisher<[Forecast], NetworkError>
}
