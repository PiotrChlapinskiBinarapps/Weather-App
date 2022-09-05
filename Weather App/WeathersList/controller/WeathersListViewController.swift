import CoreLocation
import UIKit

/// Protocol for delegate reload data in TableView
protocol WeathersListViewControllerDelegate: AnyObject {
    /// Reload data in TableView
    func reloadData() async
}

class WeathersListViewController: UIViewController {
    @IBOutlet var weatherTableView: UITableView!
    private let userLocationViewModel = UserLocationManagerImpl()
    var cityWeatherViewModel: CityWeatherViewModel!

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        cityWeatherViewModel = CityWeatherViewModelImpl(delegate: self)
        userLocationViewModel.configureLocationService()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(coordinateChanged),
                                               name: .coordinateChanged,
                                               object: nil)
        cityWeatherViewModel.setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherTableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.backgroundColor = .clear
    }

    @objc func coordinateChanged(_: Notification) {
        guard let coordinate = userLocationViewModel.userLocation.currentLocation else {
            return
        }
        cityWeatherViewModel.getWeatherForCoordinate(coordinate)
    }

    func addCity(_ city: City) {
        cityWeatherViewModel.getWeatherForCity(city)
    }
}

extension WeathersListViewController: UITableViewDataSource {
    public func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cityWeatherViewModel.weatherForLocation == nil ? 0 : 1
        }

        return cityWeatherViewModel.weathers.count
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
            guard let weather = cityWeatherViewModel.weatherForLocation else {
                return UITableViewCell()
            }
            name = weather.name
            degree = "\(Int(weather.mesurements.temperature))"
        } else {
            name = cityWeatherViewModel.weathers[indexPath.row].name
            degree = "\(cityWeatherViewModel.weathers[indexPath.row].mesurements.temperature)"
        }

        cell.cityLabel.text = name
        cell.degreeLabel.text = "\(degree) °C"

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if cityWeatherViewModel.weatherForLocation != nil, indexPath == IndexPath(row: 0, section: 0) {
            return
        }

        if editingStyle == .delete {
            cityWeatherViewModel.removeWeather(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
        if sender == IndexPath(row: 0, section: 0), cityWeatherViewModel.weatherForLocation != nil {
            segueController.weather = cityWeatherViewModel.weatherForLocation
        } else {
            segueController.weather = cityWeatherViewModel.weathers[sender.row]
        }
    }
}

extension WeathersListViewController: WeathersListViewControllerDelegate {
    func reloadData() async {
        weatherTableView.reloadData()
    }
}
