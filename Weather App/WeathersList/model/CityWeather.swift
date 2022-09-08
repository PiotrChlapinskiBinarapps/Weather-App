import Foundation

// A struct for to hold information about weather
public struct CityWeather: Decodable {
    let mesurements: Mesurements
    let description: [Description]
    let name: String
    let sun: Sun
    let wind: Wind
    let clouds: Clouds
    let date: Date
    var weatherForecast: WeatherForecast?

    private enum CodingKeys: String, CodingKey {
        case mesurements = "main"
        case description = "weather"
        case sun = "sys"
        case date = "dt"
        case name, wind, clouds, weatherForecast
    }
}

public struct Mesurements: Decodable {
    let temperature: Double
    let pressure: Double
    let humidity: Double

    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case pressure
        case humidity
    }
}

public struct Description: Decodable {
    let descriptionWeather: String
    let main: String
    let iconId: String

    private enum CodingKeys: String, CodingKey {
        case descriptionWeather = "description"
        case iconId = "icon"
        case main
    }
}

struct Sun: Decodable {
    let sunrise: Date
    let sunset: Date
}

struct Wind: Decodable {
    let velocity: Double

    private enum CodingKeys: String, CodingKey {
        case velocity = "speed"
    }
}

struct Clouds: Decodable {
    let cloudiness: Double

    private enum CodingKeys: String, CodingKey {
        case cloudiness = "all"
    }
}
