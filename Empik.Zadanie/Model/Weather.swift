//
//  Weather.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation

struct Weather: Decodable {
    let weatherText: String
    let weatherIcon: Int
    let hasPrecipitation: Bool
    let precipitationType: String?
    let isDayTime: Bool
    let temperature: Value
    let realFeelTemperature: Value
    let relativeHumidity: Int?
    let wind: Wind
    let windGust: Wind
    let UVIndex: Int
    let UVIndexText: String
    
    let visibility: Value
    let cloudCover: Int
    let pressure: Value
    let pressureTendency: LocalizedValue
    
    enum CodingKeys: String, CodingKey {
        case weatherText = "WeatherText"
        case weatherIcon = "WeatherIcon"
        case hasPrecipitation = "HasPrecipitation"
        case precipitationType = "PrecipitationType"
        case isDayTime = "IsDayTime"
        case temperature = "Temperature"
        case realFeelTemperature = "RealFeelTemperature"
        case relativeHumidity = "RelativeHumidity"
        case wind = "Wind"
        case windGust = "WindGust"
        case uvIndex = "UVIndex"
        case uvIndexText = "UVIndexText"
        case visibility = "Visibility"
        case cloudCover = "CloudCover"
        case pressure = "Pressure"
        case pressureTendency = "PressureTendency"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weatherText = try container.decode(String.self, forKey: .weatherText)
        self.weatherIcon = try container.decode(Int.self, forKey: .weatherIcon)
        self.hasPrecipitation = try container.decode(Bool.self, forKey: .hasPrecipitation)
        self.precipitationType = try container.decodeIfPresent(String.self, forKey: .precipitationType)
        self.isDayTime = try container.decode(Bool.self, forKey: .isDayTime)
        self.temperature = try container.decode(Value.self, forKey: .temperature)
        self.realFeelTemperature = try container.decode(Value.self, forKey: .realFeelTemperature)
        self.relativeHumidity = try container.decodeIfPresent(Int.self, forKey: .relativeHumidity)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.windGust = try container.decode(Wind.self, forKey: .windGust)
        self.UVIndex = try container.decode(Int.self, forKey: .uvIndex)
        self.UVIndexText = try container.decode(String.self, forKey: .uvIndexText)
        self.visibility = try container.decode(Value.self, forKey: .visibility)
        self.cloudCover = try container.decode(Int.self, forKey: .cloudCover)
        self.pressure = try container.decode(Value.self, forKey: .pressure)
        self.pressureTendency = try container.decode(LocalizedValue.self, forKey: .pressureTendency)
    }
}
