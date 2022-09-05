import CoreLocation
import UIKit

class ViewController: UIViewController {
    @IBOutlet var weatherTableView: UITableView!
    private let userLocationViewModel = UserLocationViewModelImpl()
    private let storage = StorageUserDefaults()
    var weatherForCityViewModel: WeatherForCityViewModel = WeatherForCityViewModelImpl()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        userLocationViewModel.configureLocationService()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(coordinateChanged),
                                               name: .coordinateChanged,
                                               object: nil)
        storage.fetchList().forEach { addCityCell(name: $0) }
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
            await weatherForCityViewModel.getWeatherForCoordinate(coordinate: coordinate)

            weatherTableView.reloadData()
        }
    }

    private func addCityCell(name: String) {
        Task {
            await weatherForCityViewModel.getWeatherForCity(cityName: name)

            weatherTableView.reloadData()
        }
    }

    func addCity(name: String) {
        var citiesNames = weatherForCityViewModel.weathers.map { $0.name }
        citiesNames.append(name)
        do {
            try storage.save(cities: citiesNames)
        } catch {
            print(error)
        }
        addCityCell(name: name)
    }
}

extension ViewController: UITableViewDataSource {
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if weatherForCityViewModel.weatherForLocation != nil, indexPath == IndexPath(row: 0, section: 0) {
            return
        }

        if editingStyle == .delete {
            weatherForCityViewModel.removeWeather(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let citiesNames = weatherForCityViewModel.weathers.map { $0.name }
            do {
                try storage.save(cities: citiesNames)
            } catch {
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
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
