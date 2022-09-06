import CoreLocation
import UIKit

class WeathersListViewController: UIViewController {
    @IBOutlet var weatherTableView: UITableView!
    private let userLocationViewModel = UserLocationManagerImpl()
    private let storage = StorageUserDefaults()
    private var cities: Cities
    var weatherForCityViewModel: WeatherForCityViewModel = WeatherForCityViewModelImpl()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        let listOfCities = storage.fetchList()
        cities = Cities(cities: listOfCities)
        super.init(coder: coder)
        userLocationViewModel.configureLocationService()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(coordinateChanged),
                                               name: .coordinateChanged,
                                               object: nil)

        cities.items.forEach { addCityCell($0) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherTableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.backgroundColor = .white
    }

    @objc func coordinateChanged(_: Notification) {
        Task {
            guard let coordinate = userLocationViewModel.userLocation.currentLocation else {
                return
            }
            let weather = await cities.getWeatherForCoordinate(coordinate: coordinate)

            weatherForCityViewModel.weatherForLocation = weather
            weatherTableView.reloadData()
        }
    }

    private func addCityCell(_ city: City) {
        Task {
            guard let cityWeather = await cities.getWeatherForCity(city) else {
                return
            }

            weatherForCityViewModel.weathers.append(cityWeather)
            weatherTableView.reloadData()
        }
    }

    func addCity(_ city: City) {
        guard cities.isNotContainedCity(cityName: city.plainName) else {
            return
        }
        cities.addCity(city)
        do {
            try storage.save(cities: cities.items)
        } catch {
            print(error)
        }

        addCityCell(city)
    }
}

extension WeathersListViewController: UITableViewDataSource {
    public func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return weatherForCityViewModel.weatherForLocation == nil ? 0 : 1
        }

        return weatherForCityViewModel.weathers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
            as? WeatherCell
        else {
            return tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        }
        let name: String
        let degree: String

        if indexPath.section == 0 {
            guard let weather = weatherForCityViewModel.weatherForLocation else {
                return UITableViewCell()
            }
            name = weather.name
            degree = "\(weather.mesurements.temperature)"
        } else {
            name = weatherForCityViewModel.weathers[indexPath.row].name
            degree = "\(weatherForCityViewModel.weathers[indexPath.row].mesurements.temperature)"
        }

        cell.cityLabel.text = name
        cell.degreeLabel.text = "\(degree) °C"

        return cell
    }
}

extension WeathersListViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "WeatherDetails", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueController = segue.destination as? WeatherDetailsViewController, let sender = sender as? IndexPath else {
            return
        }
        if sender == IndexPath(row: 0, section: 0), weatherForCityViewModel.weatherForLocation != nil {
            segueController.weather = weatherForCityViewModel.weatherForLocation
        } else {
            segueController.weather = weatherForCityViewModel.weathers[sender.row]
        }
    }
}
