//
//  AWError.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 06/02/2024.
//

import Foundation

struct AWError: Decodable {
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case message = "Message"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intCode = try? container.decode(Int.self, forKey: .code) {
            self.code = intCode
        } else {
            let stringCode = try container.decode(String.self, forKey: .code)
            self.code = Int(stringCode)!
        }
        self.message = try container.decode(String.self, forKey: .message)
    }
}
