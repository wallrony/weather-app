//
//  Forecast.swift
//  weather-app
//
//  Created by Rony on 11/11/22.
//

import Foundation

struct Weather: Decodable {
    struct CurrentWeather: Decodable {
        var temperature: CGFloat
        var time: String
    }
    
    struct DayForecast {
        var date: String
        var maxTemperature: CGFloat
        var minTemperature: CGFloat
    }
    
    private struct Daily: Decodable {
        var dates: [String]
        var maxTemperatures: [CGFloat]
        var minTemperatures: [CGFloat]
        
        enum CodingKeys: String, CodingKey {
            case dates = "time"
            case maxTemperatures = "temperature_2m_max"
            case minTemperatures = "temperature_2m_min"
        }
    }
    
    var todayWeather: CurrentWeather
    var forecasts: [DayForecast]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let daily = try values.decode(Daily.self, forKey: .daily)
        self.forecasts = []
        for index in 0..<daily.dates.count {
            let date = daily.dates[index]
            let formattedDate = date.components(separatedBy: "-")[1...].reversed().joined(separator: "/")
            self.forecasts.append(DayForecast(
                date: formattedDate,
                maxTemperature: daily.maxTemperatures[index],
                minTemperature: daily.minTemperatures[index]
            ))
        }
        self.todayWeather = try values.decode(CurrentWeather.self, forKey: .todayWeather)
    }
    
    enum CodingKeys: String, CodingKey {
        case daily
        case todayWeather = "current_weather"
    }
}
