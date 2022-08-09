import Foundation

// A struct for to hold information about weather
struct WeatherForCity: Decodable {
    let mesurements: Mesurements
    let description: [Description]
    let name: String

    private enum CodingKeys: String, CodingKey {
        case mesurements = "main"
        case description = "weather"
        case name
    }
}

struct Mesurements: Decodable {
    let temperature: Double
    let pressure: Double
    let humidity: Double

    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case pressure
        case humidity
    }
}

struct Description: Decodable {
    let descriptionWeather: String
    let main: String

    private enum CodingKeys: String, CodingKey {
        case descriptionWeather = "description"
        case main
    }
}
