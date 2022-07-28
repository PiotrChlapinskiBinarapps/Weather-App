//
//  UserLocationViewModel.swift
//  Weather App
//
//  Created by Piotr Chlapinski on 21/07/2022.
//

import Foundation
import MapKit

class UserLocationViewModel: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let notificationCenter: NotificationCenter = .default
    var userLocation: UserLocation = .init()

    func configureLocationService() {
        locationManager.delegate = self

        let status = locationManager.authorizationStatus

        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }

    func beginLocationUpdates(locationManager: CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            return
        }

        userLocation.currentLocation = latestLocation.coordinate
        notificationCenter.post(name: .coordinateChanged, object: nil)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension Notification.Name {
    static var coordinateChanged: Notification.Name {
        return .init(rawValue: "UserLocationViewModel.coordinateChanged")
    }
}
