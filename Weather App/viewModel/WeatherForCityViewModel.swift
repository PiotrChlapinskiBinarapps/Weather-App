import CoreLocation
import Foundation
import Keys

protocol WeatherForCityViewModel {
    var weathers: [WeatherForCity] { get }
    var weatherForLocation: WeatherForCity? { get }
    func getWeatherForCity(cityName: String) async
    func getWeatherForCoordinate(coordinate: CLLocationCoordinate2D) async
    func removeWeather(index: Int)
}

class WeatherForCityViewModelImpl: WeatherForCityViewModel {
    var weathers: [WeatherForCity] = []
    var weatherForLocation: WeatherForCity?

    func getWeatherForCity(cityName: String) async {
        let cityName = cityName.removeDiacratics()
        guard let requestURL = Bundle.main.object(forInfoDictionaryKey: "WeatherRequestURL") as? String,
              let url = URL(string: requestURL + "?q=\(cityName)" +
                  "&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return
        }
        await getWeather(url: url, isFromLocation: false, cityName: cityName)
    }

    func getWeatherForCoordinate(coordinate: CLLocationCoordinate2D) async {
        guard let requestURL = Bundle.main.object(forInfoDictionaryKey: "WeatherRequestURL") as? String,
              let url = URL(string: requestURL + "?lat=\(coordinate.latitude)" +
                  "&lon=\(coordinate.longitude)&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return
        }
        await getWeather(url: url, isFromLocation: true, cityName: nil)
    }

    private func getWeather(url: URL, isFromLocation: Bool, cityName _: String?) async {
        let session = URLSession(configuration: .default)

        do {
            let (data, _) = try await session.data(from: url)

            let decoder = JSONDecoder()

            let decoded = try decoder.decode(WeatherForCity.self, from: data)

            guard isNotContainedCity(cityName: decoded.name) else {
                return
            }
            if isFromLocation {
                weatherForLocation = decoded
            } else {
                weathers.append(decoded)
            }
        } catch {
            print(error)
        }
    }

    private func isNotContainedCity(cityName: String?) -> Bool {
        guard let cityName = cityName else {
            return true
        }

        let city = cityName.removeDiacratics()
        let isContained = weathers.contains {
            $0.name.removeDiacratics() == city
        }
        return !isContained
    }

    func removeWeather(index: Int) {
        weathers.remove(at: index)
    }
}
