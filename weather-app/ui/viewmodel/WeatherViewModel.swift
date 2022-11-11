//
//  WeatherViewModel.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import SwiftUI
import WrappingStack
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var isNight: Bool = false
    @Published private var weather: Weather?
    var separatedForecasts: [[Weather.DayForecast]] {
        get {
            if weather == nil {
                return []
            }
            var lists: [[Weather.DayForecast]] = []
            var forecastList: [Weather.DayForecast] = []
            for index in 1...weather!.forecasts.count {
                forecastList.append(weather!.forecasts[index-1])
                if index % 3 == 0 {
                    lists.append(forecastList)
                    forecastList = []
                }
            }
            if !forecastList.isEmpty {
                lists.append(forecastList)
            }
            return lists
        }
    }
    
    private var service: WeatherUseCase
    
    required init(service: WeatherUseCase) {
        self.service = service
    }
    
    func currentLocationView(placemark: CLPlacemark?) -> some View {
        VStack(alignment: .leading) {
            WAText(placemark?.locality ?? "Loading...", fontSize: 32, weight: .semibold, design: .rounded)
            WAText(placemark?.administrativeArea ?? "", fontSize: 32, weight: .bold, design: .rounded)
        }
    }
    
    var currentTemperatureCard: some View {
        VStack(alignment: .trailing) {
            WAFittedSystemImage(systemImageName: self.isNight ? "moon.stars.fill" : "cloud.sun.fill",
                                height: 36,
                                renderingMode: .multicolor)
            if weather == nil {
                ProgressView().progressViewStyle(CircularProgressViewStyle()).frame(alignment: .center)
            } else {
                let temperature: String = weather!.todayWeather.temperature.formatted()
                WAText("\(temperature)º", fontSize: 24, weight: .semibold)
            }
        }
    }
    
    @ViewBuilder
    var lastTemperatureTimeUpdate: some View {
        if weather == nil {
            EmptyView()
        } else {
            let time: String = self.weather!.todayWeather.time.components(separatedBy: "T")[1]
            WAText("Última atualização: \(time)", fontSize: 16, weight: .semibold)
        }
    }
    
    var weekTemperaturesList: some View {
        VStack(alignment: .leading) {
            HStack {
                WAText("Forecasts", fontSize: 24, weight: .bold)
                Spacer()
            }
            if self.weather == nil {
                HStack {
                    Spacer()
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
            } else {
                Grid(alignment: .center) {
                    ForEach(0..<self.separatedForecasts.count, id: \.self) {
                        let forecastsGroup = self.separatedForecasts[$0]
                        GridRow {
                            ForEach(0..<forecastsGroup.count, id: \.self) {
                                let forecast = forecastsGroup[$0]
                                WeatherDayView(
                                    date: forecast.date,
                                    systemImageName: "cloud.sun.fill",
                                    minTemperature: forecast.minTemperature,
                                    maxTemperature: forecast.maxTemperature
                                )
                            }
                        }
                    }
                }
            }
        }.padding(.horizontal, 8)
            .padding(.vertical, 16)
            .cornerRadius(8)
    }
    
    func toggleDayTime() {
        self.isNight = !self.isNight
    }
    
    func fetch(latitude: String, longitude: String) {
        Task { @MainActor in
            do {
                let latlng = LatLng(latitude: latitude, longitude: longitude)
                self.weather = try await self.service.fetchForecast(latlng: latlng)
            } catch let error as DomainError {
                print(error.message)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

struct WeatherDayView: View {
    var date: String
    var systemImageName: String
    var minTemperature: CGFloat
    var maxTemperature: CGFloat
    
    var temperature: String {
        get {
            return "\(self.minTemperature)º/\(self.maxTemperature)º"
        }
    }
    
    var body: some View {
        VStack {
            WAFittedSystemImage(
                systemImageName: self.systemImageName,
                height: 40,
                renderingMode: .multicolor
            )
            WAText(self.date, fontSize: 18)
            VStack(alignment: .leading) {
                WAText("Max: \(self.maxTemperature.formatted())º", fontSize: 16)
                WAText("Min: \(self.minTemperature.formatted())º", fontSize: 16)
            }
        }.frame(minWidth: 90)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(Color(.white.withAlphaComponent(0.2)))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.2), radius: 4)
    }
}
