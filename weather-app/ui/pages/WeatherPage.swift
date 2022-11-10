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
        ZStack {
            BackgroundView(isNight: $viewModel.isNight)
            if let coordinates = locationManager.locationCoords {
                VStack(spacing: 16) {
                    HStack {
                        viewModel.currentLocationView
                        Spacer()
                        viewModel.currentTemperatureCard
                    }.padding(.bottom, 40).padding(.horizontal, 16)
                    viewModel.weekTemperaturesList
                    Spacer()
                    ChangeDayTimeButton(onClick: viewModel.toggleDayTime, isNight: $viewModel.isNight)
                    Spacer().frame(height: 40)
                }.onAppear(perform: {
                    print(String(coordinates.latitude))
                    print(String(coordinates.longitude))
                    self.viewModel.fetchCurrent(
                        latitude: String(coordinates.latitude),
                        longitude: String(coordinates.longitude))
                })
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
    
    func onChangeCoordinates(coordinates: CLLocationCoordinate2D) {
        viewModel.fetchCurrent(
            latitude: coordinates.latitude.formatted(),
            longitude: coordinates.longitude.formatted())
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
        let bottomColor: Color = self.isNight ? .gray : Color("LightBlue")
        LinearGradient(
            gradient: Gradient(colors: [topColor, bottomColor]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).edgesIgnoringSafeArea(.all)
            .preferredColorScheme(.dark)
    }
}
