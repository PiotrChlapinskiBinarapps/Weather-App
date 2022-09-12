import CoreLocation
import Foundation
import Keys

/// Protocol for provides weather/forecast from Api
protocol WeatherRepository {
    /// Give weather for selected city
    /// - Parameters:
    ///   - city: City for which the weather will be downloaded
    func getWeatherForCity(_ city: City) async throws -> CityWeather?
    /// Give weather for selected coordinate
    /// - Parameters:
    ///   - coordinate: CLLocationCoordinate2D for which the weather will be downloaded
    func getWeatherForCoordinate(_ coordinate: CLLocationCoordinate2D) async throws -> CityWeather?
    /// Give weather forecast for selected index
    /// - Parameters:
    ///   - cityName: String for which the weather forecast will be downloaded
    func getWeatherForecastForCity(_ cityName: String) async throws -> WeatherForecast?
}

class WeatherRepositoryImpl: WeatherRepository {
    public let session: URLSession
    let requestWeatherUrl: String
    let requestForecastUrl: String

    init() {
        session = URLSession(configuration: .default)
        guard let weatherURL = Bundle.main.object(forInfoDictionaryKey: "WeatherRequestURL") as? String, let forecastURL = Bundle.main.object(forInfoDictionaryKey: "ForecastWeatherRequestURL") as? String else {
            fatalError("Incorrect Open Weather URL ")
        }

        requestWeatherUrl = weatherURL
        requestForecastUrl = forecastURL
    }

    public func getWeatherForCity(_ city: City) async throws -> CityWeather? {
        guard let url = URL(string: requestWeatherUrl + "?q=\(city.plainName)" +
            "&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return nil
        }
        return try await getWeather(url: url, isFromLocation: false)
    }

    public func getWeatherForCoordinate(_ coordinate: CLLocationCoordinate2D) async throws -> CityWeather? {
        guard let url = URL(string: requestWeatherUrl + "?lat=\(coordinate.latitude)" +
            "&lon=\(coordinate.longitude)&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return nil
        }
        return try await getWeather(url: url, isFromLocation: true)
    }

    private func getWeather(url: URL, isFromLocation _: Bool) async throws -> CityWeather? {
        let (data, _) = try await session.data(from: url)

        let decoder = JSONDecoder()

        return try decoder.decode(CityWeather.self, from: data)
    }

    public func getWeatherForecastForCity(_ cityName: String) async throws -> WeatherForecast? {
        guard let url = URL(string: requestForecastUrl + "?q=\(cityName.removeDiacratics())" +
            "&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return nil
        }
        return try await getForecast(url: url, isFromLocation: false)
    }

    private func getForecast(url: URL, isFromLocation _: Bool) async throws -> WeatherForecast? {
        let (data, _) = try await session.data(from: url)

        let decoder = JSONDecoder()

        return try decoder.decode(WeatherForecast.self, from: data)
    }
}
