//
//  WeatherPage.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import SwiftUI
import CoreLocation

struct WeatherPage: View {
    @ObservedObject var viewModel: WeatherViewModel
    @StateObject var locationManager = WALocationManager()
    
    init() {
        self.viewModel = WeatherViewModel(service: WeatherService(adapter: WeatherAPI()))
    }

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(isNight: $viewModel.isNight)
                if let coordinates = locationManager.locationCoords {
                    let _ = print("Coordinates:", coordinates)
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    viewModel.currentLocationView(placemark: self.locationManager.currentPlacemark)
                                    Spacer()
                                    viewModel.currentTemperatureCard
                                }.padding(.bottom, 8).padding(.horizontal, 8)
                                viewModel.weekTemperaturesList
                                viewModel.lastTemperatureTimeUpdate
                                    .padding(.horizontal, 8)
                                    .padding(.bottom, 16)
                                Spacer()
                            }.onAppear(perform: {
                                self.locationManager.addListener(fn: { (coordinates) in
                                    onChangeCoordinates(coordinates: coordinates)
                                })
                                onChangeCoordinates(coordinates: coordinates)
                            }).padding(.horizontal, 20)
                        }.toolbar {
                            Toggle(isOn: $viewModel.isNight, label: {
                                Image(systemName: "moon.stars.fill")
                                    .symbolRenderingMode(.multicolor)
                            }).padding(.trailing, 16)
                        }.padding(.top, 16)
                } else {
                    Button("Share my Current Location", action: {
                        locationManager.requestLocation()
                    }).padding()
                        .background(viewModel.isNight ? Color.white : Color.black.opacity(0.8))
                        .foregroundColor(viewModel.isNight ? Color.black : Color.white)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    func onChangeCoordinates(coordinates: CLLocationCoordinate2D) {
        viewModel.fetch(
            latitude: "\(coordinates.latitude)",
            longitude: "\(coordinates.longitude)"
        )
    }
}

struct WeatherPage_Previews: PreviewProvider {
    static var previews: some View {
        WeatherPage()
    }
}

struct ChangeDayTimeButton: View {
    var onClick: () -> Void
    @Binding var isNight: Bool
    
    var body: some View {
        let foregroundColor: Color = isNight ? .white : Color(.black.withAlphaComponent(0.8))
        let backgroundColor: Color = isNight ? .black : .white
        
        Button("Change Day Time", action: self.onClick)
            .foregroundColor(foregroundColor)
            .padding(12)
            .padding(.horizontal, 16)
            .background(backgroundColor)
            .cornerRadius(8)
            .font(.system(size: 24, weight: .bold))
            .shadow(radius: 4)
    }
}

struct BackgroundView: View {
    @Binding var isNight: Bool
    
    var body: some View {
        let topColor: Color = self.isNight ? .black : .blue
        LinearGradient(
            gradient: Gradient(colors: [topColor, Color("lightBlue")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).edgesIgnoringSafeArea(.all)
            .preferredColorScheme(.dark)
    }
}
