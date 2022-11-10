//
//  Location.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import Foundation

struct Location: Decodable {
    var name: String
    var region: String
    var country: String
    var latitude: String
    var longitude: String
    var timezone: String
    var datetime: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.region = try values.decode(String.self, forKey: .region)
        self.country = try values.decode(String.self, forKey: .country)
        let latValue = try values.decode(Float.self, forKey: .latitude)
        self.latitude = String(latValue)
        let lonValue = try values.decode(Float.self, forKey: .longitude)
        self.longitude = String(lonValue)
        self.timezone = try values.decode(String.self, forKey: .timezone)
        self.datetime = try values.decode(String.self, forKey: .datetime)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case region
        case country
        case latitude = "lat"
        case longitude = "lon"
        case timezone = "tz_id"
        case datetime = "localtime"
    }
}
