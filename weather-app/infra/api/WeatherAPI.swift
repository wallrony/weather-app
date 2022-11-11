//
//  WeatherAPI.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import Foundation

class WeatherAPI: WeatherAdapter {
    private let baseURL: String = "https://api.open-meteo.com/v1"
    
    func fetchForecast(latlng: LatLng) async throws -> Weather {
        let request = self.prepareRequest(
            path: "forecast",
            latlng: latlng,
            queryItems: [
                URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min"),
                URLQueryItem(name: "current_weather", value: "true"),
            ]
        )
        let data = try await self.executeRequest(request: request)
        return try JSONDecoder().decode(Weather.self, from: data)
    }
    
    private func prepareRequest(path: String, latlng: LatLng, queryItems: [URLQueryItem] = []) -> URLRequest {
        var url = URL(string: self.baseURL)!
        url.append(path: path)
        url.append(queryItems: [
            URLQueryItem(name: "timezone", value: "America/Sao_Paulo"),
            URLQueryItem(name: "latitude", value: latlng.latitude),
            URLQueryItem(name: "longitude", value: latlng.longitude),
        ] + queryItems)
        return URLRequest(url: url)
    }
    
    private func executeRequest(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        try self.handleResponse(response: response as! HTTPURLResponse, data: data)
        return data
    }
    
    private func handleResponse(response: HTTPURLResponse, data: Data) throws {
        let statusCode = response.statusCode
        if statusCode >= 400 {
            let dict = try JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            ) as! [String: Any]
            if let reason = dict["reason"] {
                throw DomainError(message: "\(reason)")
            }
            throw DomainError.unexpectedError()
        }
    }
}
