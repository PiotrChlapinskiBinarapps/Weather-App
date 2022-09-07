import CoreLocation
import Foundation
import Keys

/// Protocol for objects that can provide weathers
public protocol WeatherForCityViewModel {
    /// Variable which contains list of wather for city selected by user
    var weathers: [CityWeather] { get set }
    /// Variable which contains weather for place where user is now
    var weatherForLocation: CityWeather? { get set }
    /// Give weather for selected city
    /// - Parameters:
    ///   - city: City for which the weather will be downloaded
    func getWeatherForCity(_ city: City)
    /// Give weather for selected coordinate
    /// - Parameters:
    ///   - coordinate: CLLocationCoordinate2D for which the weather will be downloaded
    func getWeatherForCoordinate(_ coordinate: CLLocationCoordinate2D)
    /// Get weather for cities from storage.
    func setup()
}

class WeatherForCityViewModelImpl: WeatherForCityViewModel {
    public var weathers: [CityWeather] = []
    public var weatherForLocation: CityWeather?
    private let citiesRepository: CitiesRepository
    private let storage: Storage
    private let delegate: WeathersListViewControllerDelegate
    private var cities: Cities

    init(delegate: WeathersListViewControllerDelegate, storage: Storage = StorageUserDefaults(), citiesRepository: CitiesRepository = CitiesRepository()) {
        self.storage = storage
        self.citiesRepository = citiesRepository
        let list = storage.fetchList()
        cities = Cities(items: list)
        self.delegate = delegate
    }

    func setup() {
        for city in cities.items {
            Task {
                if let weather = await citiesRepository.getWeatherForCity(city) {
                    weathers.append(weather)
                    await delegate.reloadData()
                }
            }
        }
    }

    public func getWeatherForCity(_ city: City) {
        Task {
            guard let weather = await citiesRepository.getWeatherForCity(city) else {
                return
            }

            if cities.isNotContainedCity(cityName: city.plainName) {
                weathers.append(weather)
                cities.items.append(city)

                storage.save(cities: cities.items)
                await delegate.reloadData()
            }
        }
    }

    public func getWeatherForCoordinate(_ coordinate: CLLocationCoordinate2D) {
        Task {
            let weather = await citiesRepository.getWeatherForCoordinate(coordinate)

            weatherForLocation = weather
            await delegate.reloadData()
        }
    }
}
