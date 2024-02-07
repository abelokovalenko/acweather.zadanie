//
//  AWCity.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import Foundation

struct AdmArea: Decodable {
    let id: String
    let localizedName: String
    let englishName: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.localizedName = try container.decode(String.self, forKey: .localizedName)
        self.englishName = try? container.decode(String.self, forKey: .englishName)
    }
}

struct AWCity: Decodable {
    let key: String
    let type: String
    let rank: Int
    let localizedName: String
    let englishName: String?
    let country: AdmArea
    let administrativeArea: AdmArea
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case type = "Type"
        case rank = "Rank"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case country = "Country"
        case administrativeArea = "AdministrativeArea"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decode(String.self, forKey: .key)
        self.type = try container.decode(String.self, forKey: .type)
        self.rank = try container.decode(Int.self, forKey: .rank)
        self.localizedName = try container.decode(String.self, forKey: .localizedName)
        self.englishName = try? container.decode(String.self, forKey: .englishName)
        self.country = try container.decode(AdmArea.self, forKey: .country)
        self.administrativeArea = try container.decode(AdmArea.self, forKey: .administrativeArea)
    }
}
