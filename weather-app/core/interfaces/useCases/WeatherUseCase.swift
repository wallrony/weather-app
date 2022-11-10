//
//  WeatherUseCase.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import Foundation

protocol WeatherUseCase {
    init(adapter: WeatherAdapter);
    
    func fetchCurrent(latitude: String, longitude: String) async throws -> Weather
}
