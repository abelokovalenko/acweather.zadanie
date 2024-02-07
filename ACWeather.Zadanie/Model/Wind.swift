//
//  Wind.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 07/02/2024.
//

import Foundation

struct Wind: Decodable {
    let direction: String?
    let speed: Value
    
    enum CodingKeys: String, CodingKey {
        case direction = "Direction"
        case localized = "Localized"
        case speed = "Speed"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let directionContainer = try? container.nestedContainer(keyedBy: CodingKeys.self,
                                                                   forKey: .direction) {
            direction = try? directionContainer.decode(String.self, forKey: .localized)
        } else {
            direction = nil
        }
        
        speed = try container.decode(Value.self, forKey: .speed)
    }
}
