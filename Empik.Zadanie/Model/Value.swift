//
//  Value.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 07/02/2024.
//

import Foundation

struct Value: Decodable {
    let value: Double
    let unit: String
    let unitType: Int
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
    
    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: CodingKeys.self)
        if let metricContainer = try? mainContainer.nestedContainer(keyedBy: CodingKeys.self,
                                                                    forKey: .metric) {
            
            self.value = try metricContainer.decode(Double.self, forKey: .value)
            self.unit = try metricContainer.decode(String.self, forKey: .unit)
            self.unitType = try metricContainer.decode(Int.self, forKey: .unitType)
        } else {
            self.value = try mainContainer.decode(Double.self, forKey: .value)
            self.unit = try mainContainer.decode(String.self, forKey: .unit)
            self.unitType = try mainContainer.decode(Int.self, forKey: .unitType)
        }
    }
}
