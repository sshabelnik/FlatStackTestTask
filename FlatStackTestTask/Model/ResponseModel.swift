//
//  ResponseModel.swift
//  FlatStackTestTask
//
//  Created by Сергей Шабельник on 13.06.2021.
//

import Foundation

// MARK: - Welcome
struct ResponseModel: Codable {
    let next: String
    let countries: [Country]
}

// MARK: - Country
struct Country: Codable {
    let name, continent, capital: String
    let population: Int
    let descriptionSmall, countryDescription: String
    let image: String
    let countryInfo: CountryInfo
    
    enum CodingKeys: String, CodingKey {
        case name, continent, capital, population, image
        case descriptionSmall = "description_small"
        case countryDescription = "description"
        case countryInfo = "country_info"
    }
}

// MARK: - CountryInfo
struct CountryInfo: Codable {
    let images: [String]
    let flag: String
}
