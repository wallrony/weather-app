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
                BackgroundView()
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
                        }.padding(.top, 8)
                } else {
                    Button("Share my Current Location", action: {
                        locationManager.requestLocation()
                    }).padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(Color.white)
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
    
    var body: some View {
        Button("Change Day Time", action: self.onClick)
            .foregroundColor(Color(.black.withAlphaComponent(0.8)))
            .padding(12)
            .padding(.horizontal, 16)
            .background(.white)
            .cornerRadius(8)
            .font(.system(size: 24, weight: .bold))
            .shadow(radius: 4)
    }
}

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.blue, Color("lightBlue")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).edgesIgnoringSafeArea(.all)
            .preferredColorScheme(.dark)
    }
}
