//
//  Forecast.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 06/02/2024.
//

import Foundation

struct Forecast: Decodable {
    let time: Date
    let icon: Int
    let temperature: Value
    
    enum CodingKeys: String, CodingKey {
        case time = "DateTime"
        case icon = "WeatherIcon"
        case temperature = "Temperature"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.time = try container.decode(Date.self, forKey: .time)
        self.icon = try container.decode(Int.self, forKey: .icon)
        self.temperature = try container.decode(Value.self, forKey: .temperature)
    }
}
