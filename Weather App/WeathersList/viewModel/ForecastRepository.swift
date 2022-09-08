import CoreLocation
import Foundation
import Keys

protocol ForecastRepository {
    func getWeatherForecastForCity(_ cityName: String) async -> WeatherForecast?
}

class ForecastRepositoryImpl: ForecastRepository {
    public let session: URLSession
    let requestUrl: String

    init() {
        session = URLSession(configuration: .default)
        guard let basicURL = Bundle.main.object(forInfoDictionaryKey: "ForecastWeatherRequestURL") as? String else {
            fatalError("Incorrect Open Weather URL ")
        }

        requestUrl = basicURL
    }

    public func getWeatherForecastForCity(_ cityName: String) async -> WeatherForecast? {
        guard let url = URL(string: requestUrl + "?q=\(cityName.removeDiacratics())" +
            "&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return nil
        }
        return await getWeather(url: url, isFromLocation: false)
    }

    private func getWeather(url: URL, isFromLocation _: Bool) async -> WeatherForecast? {
        do {
            let (data, _) = try await session.data(from: url)

            let decoder = JSONDecoder()

            return try decoder.decode(WeatherForecast.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
