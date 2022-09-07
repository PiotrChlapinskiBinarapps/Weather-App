import CoreLocation
import Foundation
import Keys

class CitiesRepository {
    public let session: URLSession
    let requestUrl: String

    init() {
        session = URLSession(configuration: .default)
        guard let basicURL = Bundle.main.object(forInfoDictionaryKey: "WeatherRequestURL") as? String else {
            fatalError("Incorrect Open Weather URL ")
        }

        requestUrl = basicURL
    }

    public func getWeatherForCity(_ city: City) async -> CityWeather? {
        guard let url = URL(string: requestUrl + "?q=\(city.plainName)" +
            "&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return nil
        }
        return await getWeather(url: url, isFromLocation: false)
    }

    public func getWeatherForCoordinate(_ coordinate: CLLocationCoordinate2D) async -> CityWeather? {
        guard let url = URL(string: requestUrl + "?lat=\(coordinate.latitude)" +
            "&lon=\(coordinate.longitude)&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return nil
        }
        return await getWeather(url: url, isFromLocation: true)
    }

    private func getWeather(url: URL, isFromLocation _: Bool) async -> CityWeather? {
        do {
            let (data, _) = try await session.data(from: url)

            let decoder = JSONDecoder()

            return try decoder.decode(CityWeather.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
