import CoreLocation
import Foundation
import Keys

/// Protocol for objects that can provide weathers
public protocol WeatherForCityViewModel {
    /// Variable which contains list of wather for city selected by user
    var weathers: [CityWeather] { get set }
    /// Variable which contains weather for place where user is now
    var weatherForLocation: CityWeather? { get set }
}

struct WeatherForCityViewModelImpl: WeatherForCityViewModel {
    public var weathers: [CityWeather] = []
    public var weatherForLocation: CityWeather?
}
