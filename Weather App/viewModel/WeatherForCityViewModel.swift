//
//  WeatherForCityViewModel.swift
//  Weather App
//
//  Created by Piotr Chlapinski on 20/07/2022.
//

import CoreLocation
import Foundation
import Keys

class WeatherForCityViewModel {
    var weathers: [WeatherForCity] = []

    func getWeatherForCity(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)" +
                            "&appid=\(EidolonKeys().openWeatherApiKey)&units=metric") else {
            return
        }
        getWeather(url: url)
    }

    func getWeatherForCoordinate(coordinate: CLLocationCoordinate2D) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)" +
                            "&lon=\(coordinate.longitude)&appid=\(EidolonKeys().openWeatherApiKey)&units=metric") else {
            return
        }
        getWeather(url: url)
    }

    private func getWeather(url: URL) {
        let session = URLSession(configuration: .default)

        session.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            let decoder = JSONDecoder()

            do {
                let decoded = try decoder.decode(WeatherForCity.self, from: data)
                NotificationCenter.default.post(name: .weatherReturned, object: decoded)
                self?.weathers.append(decoded)
            } catch {
                print(error)
            }
        }.resume()
    }
}

extension Notification.Name {
    static var weatherReturned: Notification.Name {
        return .init(rawValue: "WeatherForCityViewModel.weatherReturned")
    }
}
