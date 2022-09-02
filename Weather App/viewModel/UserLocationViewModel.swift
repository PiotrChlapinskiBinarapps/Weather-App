import Foundation
import MapKit

protocol UserLocationViewModel {
    var userLocation: UserLocation { get }
    func configureLocationService()
}

class UserLocationViewModelImpl: NSObject, CLLocationManagerDelegate, UserLocationViewModel {
    private let locationManager = CLLocationManager()
    private let notificationCenter: NotificationCenter = .default
    var userLocation: UserLocation = .init()

    func configureLocationService() {
        locationManager.delegate = self

        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            beginLocationUpdates(locationManager: locationManager)
        default:
            return
        }
    }

    func beginLocationUpdates(locationManager: CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
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
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            beginLocationUpdates(locationManager: manager)
        default:
            break
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension Notification.Name {
    static var coordinateChanged: Notification.Name {
        return .init(rawValue: "UserLocationViewModel.coordinateChanged")
    }
}
