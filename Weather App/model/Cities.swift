import CoreLocation
import Foundation
import Keys

public struct City: Codable, Hashable {
    let name: String
    let country: String
    let plainName: String

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        country = try values.decode(String.self, forKey: .country)
        plainName = name.removeDiacratics()
    }
}

public struct Cities {
    var items: [City]
    public let session: URLSession
    let requestUrl: String

    init(cities: [City]) {
        session = URLSession(configuration: .default)
        guard let basicURL = Bundle.main.object(forInfoDictionaryKey: "WeatherRequestURL") as? String else {
            fatalError("Incorrect Open Weather URL ")
        }

        requestUrl = basicURL
        items = cities
    }

    public func getWeatherForCity(_ city: City) async -> CityWeather? {
        guard let url = URL(string: requestUrl + "?q=\(city.plainName)" +
            "&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return nil
        }
        return await getWeather(url: url, isFromLocation: false)
    }

    public func getWeatherForCoordinate(coordinate: CLLocationCoordinate2D) async -> CityWeather? {
        guard let url = URL(string: requestUrl + "?lat=\(coordinate.latitude)" +
            "&lon=\(coordinate.longitude)&appid=\(Weather_AppKeys().openWeatherApiKey)&units=metric")
        else {
            return nil
        }
        return await getWeather(url: url, isFromLocation: true)
    }

    public func getWeather(url: URL, isFromLocation _: Bool) async -> CityWeather? {
        do {
            let (data, _) = try await session.data(from: url)

            let decoder = JSONDecoder()

            return try decoder.decode(CityWeather.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }

    public mutating func addCity(_ city: City) {
        items.append(city)
    }

    public func isNotContainedCity(cityName: String) -> Bool {
        let isContained = items.contains {
            $0.plainName == cityName
        }
        return !isContained
    }
}
