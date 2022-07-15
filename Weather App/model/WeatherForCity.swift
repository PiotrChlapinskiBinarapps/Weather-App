import Foundation

class WeatherForCity {
    var currentTemperature: Float
    var feelsTemperature: Float
    var pressure: Float
    var humidity: Float
    var windSpeed: Float
    var cloudsInPercent: Float
    var rainInLast1H: Float
    var snowInLast1H: Float
    var lastUpdate: Date
    var weatherDescription: String
    
    init(currentTemperature: Float, feelsTemperature: Float, pressure: Float, humidity: Float, windSpeed: Float, cloudsInPercent: Float, rainInLast1H: Float, snowInLast1H: Float, lastUpdate: Date, weatherDescription: String) {
        self.currentTemperature = currentTemperature
        self.feelsTemperature = feelsTemperature
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.cloudsInPercent = cloudsInPercent
        self.rainInLast1H = rainInLast1H
        self.snowInLast1H = snowInLast1H
        self.lastUpdate = lastUpdate
        self.weatherDescription = weatherDescription
    }
}
