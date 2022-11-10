//
//  WeatherViewModel.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var isNight: Bool = false
    @Published var currentWeather: Weather?
    
    private var service: WeatherUseCase
    
    required init(service: WeatherUseCase) {
        self.service = service
    }
    
    var currentLocationView: some View {
        VStack(alignment: .leading) {
            WAText(currentWeather?.location.name ?? "Loading...", fontSize: 32, weight: .semibold, design: .rounded)
            WAText(currentWeather?.location.region ?? "", fontSize: 32, weight: .bold, design: .rounded)
        }.padding()
    }
    
    var currentTemperatureCard: some View {
        VStack {
            let temperature: CGFloat = currentWeather?.temperature ?? 0
            WAFittedSystemImage(systemImageName: self.isNight ? "moon.stars.fill" : "cloud.sun.fill",
                                height: 36,
                                renderingMode: .multicolor)
            WAText("\(temperature.formatted())º", fontSize: 24, weight: .semibold)
        }.padding()
    }
    
    var weekTemperaturesList: some View {
        HStack(spacing: 24) {
            WeatherDayView(dayName: "Mon",
                           systemImageName: "cloud.sun.fill",
                           temperature: 29)
            WeatherDayView(dayName: "Tue",
                           systemImageName: "cloud.sun.rain.fill",
                           temperature: 29)
            WeatherDayView(dayName: "Wed",
                           systemImageName: "cloud.sun.bolt.fill",
                           temperature: 29)
            WeatherDayView(dayName: "Thu",
                           systemImageName: "sunset.fill",
                           temperature: 29)
            WeatherDayView(dayName: "Fri",
                           systemImageName: "cloud.moon.rain.fill",
                           temperature: 29)
        }.padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(.white.withAlphaComponent(0.15)))
            .cornerRadius(8)
    }
    
    func toggleDayTime() {
        self.isNight = !self.isNight
    }
    
    func fetchCurrent(latitude: String, longitude: String) {
        Task { @MainActor in
            do {
                self.currentWeather = try await self.service.fetchCurrent(latitude: latitude, longitude: longitude)
            } catch let error as DomainError {
                print("IRRU")
                print(error.message)
            } catch let error {
                print("IRRU2")
                print(error.localizedDescription)
            }
        }
    }
}

struct WeatherDayView: View {
    var dayName: String
    var systemImageName: String
    var temperature: Int
    
    init(dayName: String, systemImageName: String, temperature: Int) {
        self.dayName = dayName
        self.systemImageName = systemImageName
        self.temperature = temperature
    }
    
    var body: some View {
        VStack {
            WAText(self.dayName)
            WAFittedSystemImage(systemImageName: self.systemImageName,
                                height: 40,
                                renderingMode: .multicolor)
            WAText("\(self.temperature)º", fontSize: 24, weight: .semibold)
        }
    }
}
