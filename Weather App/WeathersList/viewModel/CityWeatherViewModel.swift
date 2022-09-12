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
    /// Remove weather for selected index
    /// - Parameters:
    ///   - indexPath: IndexPath for which the weather  will be removed
    func removeWeather(index: Int)
    /// Give weather forecast for selected index
    /// - Parameters:
    ///   - indexPath: IndexPath for which the weather forecast will be downloaded
    func getForecastForCity(_ indexPath: IndexPath)
}

class CityWeatherViewModelImpl: CityWeatherViewModel {
    public var weathers: [CityWeather] = []
    public var weatherForLocation: CityWeather?
    private let weatherRepository: WeatherRepository
    private let storage: Storage
    private let delegate: WeathersListViewControllerDelegate
    private var cities: Cities

    init(delegate: WeathersListViewControllerDelegate, storage: Storage = StorageUserDefaults(), weatherRepository: WeatherRepository = WeatherRepositoryImpl()) {
        self.storage = storage
        self.weatherRepository = weatherRepository
        let list = storage.fetchList()
        cities = Cities(items: list)
        self.delegate = delegate
    }

    func setup() {
        weathers.removeAll()
        Task {
            for city in cities.items {
                do {
                    if let weather = try await weatherRepository.getWeatherForCity(city) {
                        weathers.append(weather)
                        await delegate.reloadData()
                    }
                } catch {
                    await delegate.presentErrorDecoderWeather(error)
                }
            }
        }
    }

    public func getWeatherForCity(_ city: City) {
        Task {
            do {
                guard let weather = try await weatherRepository.getWeatherForCity(city) else {
                    return
                }

                if cities.isNotContainedCity(cityName: city.plainName) {
                    weathers.append(weather)
                    cities.items.append(city)

                    storage.save(cities: cities.items)
                    await delegate.reloadData()
                }
            } catch {
                await delegate.presentErrorDecoderWeather(error)
            }
        }
    }

    public func getWeatherForCoordinate(_ coordinate: CLLocationCoordinate2D) {
        Task {
            do {
                guard let weather = try await weatherRepository.getWeatherForCoordinate(coordinate), !weather.name.isEmpty else {
                    return
                }

                weatherForLocation = weather
                await delegate.reloadData()
            } catch {
                await delegate.presentErrorDecoderWeather(error)
            }
        }
    }

    public func removeWeather(index: Int) {
        weathers.remove(at: index)
        cities.items.remove(at: index)
        storage.save(cities: cities.items)
    }

    public func getForecastForCity(_ indexPath: IndexPath) {
        Task {
            do {
                let weatherForecast: WeatherForecast?
                if indexPath == IndexPath(row: 0, section: 0), weatherForLocation?.weatherForecast == nil {
                    weatherForecast = try await weatherRepository.getWeatherForecastForCity(weatherForLocation?.name ?? "")
                    weatherForLocation?.weatherForecast = weatherForecast
                } else if weathers[indexPath.row].weatherForecast == nil, indexPath != IndexPath(row: 0, section: 0) {
                    let cityName = weathers[indexPath.row].name
                    weatherForecast = try await weatherRepository.getWeatherForecastForCity(cityName)
                    weathers[indexPath.row].weatherForecast = weatherForecast
                }
                await delegate.prepareSegue(withIdentifier: "WeatherDetails", indexPath: indexPath)
            } catch {
                await delegate.presentErrorDecoderWeather(error)
            }
        }
    }
}
