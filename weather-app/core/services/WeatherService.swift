//
//  WeatherService.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import Foundation

class WeatherService: WeatherUseCase {
    private var adapter: WeatherAdapter
    
    required init(adapter: WeatherAdapter) {
        self.adapter = adapter
    }
    
    func fetchCurrent(latitude: String, longitude: String) async throws -> Weather {
        return try await self.adapter.fetchCurrent(latitude: latitude, longitude: longitude)
    }
}
