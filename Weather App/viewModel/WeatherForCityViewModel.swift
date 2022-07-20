//
//  WeatherForCityViewModel.swift
//  Weather App
//
//  Created by Piotr Chlapinski on 20/07/2022.
//

import Foundation
import Keys

class WeatherForCityViewModel {
    
    var weathers: [WeatherForCity] = []
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(EidolonKeys().openWeatherApiKey)") else {
            return
        }
        let session = URLSession(configuration: .default)
        
        let _ = session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decoded = try decoder.decode(WeatherForCity.self, from: data)
                self?.weathers.append(decoded)
            } catch {
                print(error)
            }
        }.resume()
    }
    
}
