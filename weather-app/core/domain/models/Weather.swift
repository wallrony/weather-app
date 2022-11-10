//
//  Weather.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import Foundation

struct Weather: Decodable {
    // Celcius temperature
    var temperature: CGFloat
    var isDay: Bool
    var cloudPerc: CGFloat
    var humidityPerc: CGFloat
    var updatedAt: String
    var location: Location
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let current = try values.nestedContainer(keyedBy: WeatherCurrentKeys.self, forKey: .current)
        
        self.temperature = try current.decode(CGFloat.self, forKey: .temperature)
        self.isDay = try current.decode(Int.self, forKey: .isDay) > 0
        self.cloudPerc = try current.decode(CGFloat.self, forKey: .cloudPerc)
        self.humidityPerc = try current.decode(CGFloat.self, forKey: .humidityPerc)
        self.updatedAt = try current.decode(String.self, forKey: .updatedAt)
        self.location = try Location(from: values.superDecoder(forKey: .location))
    }
    
    enum CodingKeys: String, CodingKey {
        case location
        case current
    }
    
    enum WeatherCurrentKeys: String, CodingKey {
        case temperature = "temp_c"
        case isDay = "is_day"
        case cloudPerc = "cloud"
        case humidityPerc = "humidity"
        case updatedAt = "last_updated"
    }
}
