//
//  WeatherAPI.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import Foundation

class WeatherAPI: WeatherAdapter {
    func fetchCurrent(latitude: String, longitude: String) async throws -> Weather {
        var url = URL(string: "https://api.weatherapi.com/v1/current.json")!
        url.append(queryItems: [
            URLQueryItem(name: "key", value: ""),
            URLQueryItem(name: "q", value: "\(latitude),\(longitude)")
        ])
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if statusCode == 403 {
                throw DomainError(message: "You need to provide an Weather API Key to make requests")
            }
            throw DomainError.unexpectedError()
        }
        let weather = try JSONDecoder().decode(Weather.self, from: data)
        return weather
    }
}
