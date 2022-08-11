import CoreLocation
import Foundation
import Keys

protocol WeatherForCityViewModel {
    var weathers: [WeatherForCity] { get }
    func getWeatherForCity(cityName: String) async
    func getWeatherForCoordinate(coordinate: CLLocationCoordinate2D) async
}

class WeatherForCityViewModelImpl: WeatherForCityViewModel {
    var weathers: [WeatherForCity] = []

    func getWeatherForCity(cityName: String) async {
        let city = cityName.removeDiacratics()
        let isContained = weathers.contains {
            $0.name.removeDiacratics() == city
        }
        guard !isContained, let requestURL = Bundle.main.object(forInfoDictionaryKey: "WeatherRequestURL") as? String,
              let url = URL(string: requestURL + "?q=\(city)" +
                  "&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return
        }
        await getWeather(url: url)
    }

    func getWeatherForCoordinate(coordinate: CLLocationCoordinate2D) async {
        guard let requestURL = Bundle.main.object(forInfoDictionaryKey: "WeatherRequestURL") as? String,
              let url = URL(string: requestURL + "?lat=\(coordinate.latitude)" +
                  "&lon=\(coordinate.longitude)&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return
        }
        await getWeather(url: url)
    }

    private func getWeather(url: URL) async {
        let session = URLSession(configuration: .default)

        do {
            let (data, _) = try await session.data(from: url)

            let decoder = JSONDecoder()

            let decoded = try decoder.decode(WeatherForCity.self, from: data)
            weathers.append(decoded)
        } catch {
            print(error)
        }
    }
}

extension Notification.Name {
    static var weatherReturned: Notification.Name {
        return .init(rawValue: "WeatherForCityViewModel.weatherReturned")
    }
}

extension String {
    func removeDiacratics() -> String {
        return folding(options: .diacriticInsensitive, locale: Locale(identifier: "en_us")).lowercased().replacingOccurrences(of: "ł", with: "l")
    }
}
