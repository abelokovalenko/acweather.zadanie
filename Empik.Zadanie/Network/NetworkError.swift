//
//  NetworkError.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation

enum NetworkError: Error {
    case service(ServiceError)
    case common(String)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .service(let serviceError):
            return serviceError.localizedDescription
        case .common(let text):
            return text
        }
    }
}
