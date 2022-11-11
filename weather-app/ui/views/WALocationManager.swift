//
//  WALocationManager.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import CoreLocation

class WALocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    private var listeners: [(CLLocationCoordinate2D) -> Void] = []
    @Published var currentPlacemark: CLPlacemark?
    @Published var locationCoords: CLLocationCoordinate2D? {
        didSet {
            for listener in listeners {
                if locationCoords != nil {
                    listener(locationCoords!)
                }
            }
        }
    }

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func addListener(fn: @escaping (CLLocationCoordinate2D) -> Void) {
        self.listeners.append(fn)
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.locationCoords = locations.last?.coordinate
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            self.currentPlacemark = placemark?.last
        }
    }
}
