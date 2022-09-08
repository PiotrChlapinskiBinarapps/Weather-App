import CoreLocation
import Foundation
import Keys

/// Protocol for objects that can provide weathers
public protocol CityWeatherViewModel {
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
    func removeWeather(index: Int)
    /// Give weather forecast for selected index
    /// - Parameters:
    ///   - indexPath: IndexPath for which the weather forecast will be downloaded
    func getForecastForCity(_ indexPath: IndexPath)
}

class CityWeatherViewModelImpl: CityWeatherViewModel {
    public var weathers: [CityWeather] = []
    public var weatherForLocation: CityWeather?
    private let citiesRepository: CitiesRepository
    private let forecastRepository: ForecastRepositoryImpl

    private let storage: Storage
    private let delegate: WeathersListViewControllerDelegate
    private var cities: Cities

    init(delegate: WeathersListViewControllerDelegate, storage: Storage = StorageUserDefaults(), citiesRepository: CitiesRepository = CitiesRepository(), forecastRepository: ForecastRepositoryImpl = ForecastRepositoryImpl()) {
        self.storage = storage
        self.citiesRepository = citiesRepository
        let list = storage.fetchList()
        cities = Cities(items: list)
        self.delegate = delegate
        self.forecastRepository = forecastRepository
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

    public func removeWeather(index: Int) {
        weathers.remove(at: index)
        cities.items.remove(at: index)
        storage.save(cities: cities.items)
    }

    public func getForecastForCity(_ indexPath: IndexPath) {
        Task {
            let weatherForecast: WeatherForecast?
            if indexPath == IndexPath(row: 0, section: 0), weatherForLocation?.weatherForecast == nil {
                weatherForecast = await forecastRepository.getWeatherForecastForCity(weatherForLocation?.name ?? "")
                weatherForLocation?.weatherForecast = weatherForecast
            } else if weathers[indexPath.row].weatherForecast == nil {
                let cityName = weathers[indexPath.row].name
                weatherForecast = await forecastRepository.getWeatherForecastForCity(cityName)
                weathers[indexPath.row].weatherForecast = weatherForecast
            }
            await delegate.prepareSegue(withIdentifier: "WeatherDetails", indexPath: indexPath)
        }
    }
}
