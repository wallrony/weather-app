//
//  WeatherAdapter.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import Foundation

protocol WeatherAdapter {
    func fetchForecast(latlng: LatLng) async throws -> Weather
}
