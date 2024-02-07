//
//  LocalizedValue.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 07/02/2024.
//

import Foundation

struct LocalizedValue: Decodable {
    let localizedText: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case localizedText = "LocalizedText"
        case code = "Code"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.localizedText = try container.decode(String.self, forKey: .localizedText)
        self.code = try container.decode(String.self, forKey: .code)
    }
}
