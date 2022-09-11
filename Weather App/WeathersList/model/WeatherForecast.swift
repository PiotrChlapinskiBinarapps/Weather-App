import Foundation

public struct WeatherForecast: Decodable {
    let list: [OneForecast]

    private enum CodingKeys: String, CodingKey {
        case list
    }

    func fetchForecastTodayAndNextDay(_ day: Date) -> [OneForecast] {
        let formatter = DateFormatter.shortDateFormatter
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: day)!
        let forecast = list.filter { formatter.string(from: $0.date) == formatter.string(from: day) || formatter.string(from: $0.date) == formatter.string(from: nextDay) }
        return forecast
    }

    func fetchForecastForNextDays() -> [OneForecast] {
        let formatter = DateFormatter.shortTimeFormatter
        let forecast = list.filter { formatter.string(from: $0.date) == "12:00" }
        return forecast
    }
}

public struct OneForecast: Decodable {
    let mesurements: Measurements
    let description: [Description]
    let wind: Wind
    let clouds: Clouds
    let date: Date

    private enum CodingKeys: String, CodingKey {
        case mesurements = "main"
        case description = "weather"
        case date = "dt"
        case wind, clouds
    }
}
