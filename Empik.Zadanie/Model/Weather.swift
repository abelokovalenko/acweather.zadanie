//
//  Weather.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
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

struct Value: Decodable {
    let value: Double
    let unit: String
    let unitType: Int
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(Double.self, forKey: .value)
        self.unit = try container.decode(String.self, forKey: .unit)
        self.unitType = try container.decode(Int.self, forKey: .unitType)
    }
}

struct Wind: Decodable {
    struct Direction: Decodable {
      let degrees: Double
        let Localized: String
        let English: String
    }
    
    let Speed: CombinedValue
}

struct CombinedValue: Decodable {
    let metric: Value
    let imperial: Value
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        case imperial = "Imperial"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.metric = try container.decode(Value.self, forKey: .metric)
        self.imperial = try container.decode(Value.self, forKey: .imperial)
    }
}

struct Weather: Decodable {
    let weatherText: String
    let weatherIcon: Int
    let hasPrecipitation: Bool
    let precipitationType: String?
    let isDayTime: Bool
    let temperature: CombinedValue
    let realFeelTemperature: CombinedValue
    let relativeHumidity: Int?
    let wind: Wind
    let windGust: Wind
    let UVIndex: Int
    let UVIndexText: String
    
    let visibility: CombinedValue
    let cloudCover: Int
    let pressure: CombinedValue
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
        self.temperature = try container.decode(CombinedValue.self, forKey: .temperature)
        self.realFeelTemperature = try container.decode(CombinedValue.self, forKey: .realFeelTemperature)
        self.relativeHumidity = try container.decodeIfPresent(Int.self, forKey: .relativeHumidity)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.windGust = try container.decode(Wind.self, forKey: .windGust)
        self.UVIndex = try container.decode(Int.self, forKey: .uvIndex)
        self.UVIndexText = try container.decode(String.self, forKey: .uvIndexText)
        self.visibility = try container.decode(CombinedValue.self, forKey: .visibility)
        self.cloudCover = try container.decode(Int.self, forKey: .cloudCover)
        self.pressure = try container.decode(CombinedValue.self, forKey: .pressure)
        self.pressureTendency = try container.decode(LocalizedValue.self, forKey: .pressureTendency)
    }
}
