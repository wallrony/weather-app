//
//  WeatherUseCase.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import Foundation

protocol WeatherUseCase {
    init(adapter: WeatherAdapter);
    
    func fetchForecast(latlng: LatLng) async throws -> Weather
}
