import CoreLocation
import UIKit

/// Protocol for delegate reload data in TableView
public protocol WeathersListViewControllerDelegate: AnyObject {
    /// Reload data in TableView
    func reloadData() async
    /// Initiates the segue with the specified identifier.
    func prepareSegue(withIdentifier: String, indexPath: IndexPath) async
    /// Present alert with received error
    /// - Parameters:
    ///   - error: Error for which presented in message
    func presentErrorDecoderWeather(_ error: Error) async
}

class WeathersListViewController: UIViewController, AlertPresenting {
    @IBOutlet var weatherTableView: UITableView!
    @IBOutlet var reloadButton: UIButton!
    var cityWeatherViewModel: CityWeatherViewModel!
    private let userLocationViewModel = UserLocationManagerImpl()

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

    func addCity(_ city: City) {
        cityWeatherViewModel.getWeatherForCity(city)
    }

    @IBAction func reloadWeathers(_: Any) {
        cityWeatherViewModel.setup()
        reloadCoordinateWeather()
    }

    @objc func coordinateChanged(_: Notification) {
        reloadCoordinateWeather()
    }

    private func reloadCoordinateWeather() {
        guard let coordinate = userLocationViewModel.userLocation.currentLocation else {
            return
        }
        cityWeatherViewModel.getWeatherForCoordinate(coordinate)
    }
}

extension WeathersListViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        let degree: Double

        if indexPath.section == 0 {
            guard let weather = cityWeatherViewModel.weatherForLocation else {
                return UITableViewCell()
            }
            name = weather.name
            degree = weather.mesurements.temperature
        } else {
            name = cityWeatherViewModel.weathers[indexPath.row].name
            degree = cityWeatherViewModel.weathers[indexPath.row].mesurements.temperature
        }

        cell.cityLabel.text = name
        let temperature = Measurement(value: degree, unit: UnitTemperature.celsius)
        cell.degreeLabel.text = temperature.withoutDigits

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
        weatherTableView.allowsSelection = false
        cityWeatherViewModel.getForecastForCity(indexPath)
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
    public func reloadData() async {
        weatherTableView.reloadData()
    }

    public func prepareSegue(withIdentifier: String, indexPath: IndexPath) async {
        performSegue(withIdentifier: withIdentifier, sender: indexPath)
        weatherTableView.allowsSelection = true
    }

    public func presentErrorDecoderWeather(_ error: Error) async {
        let action = UIAlertAction(title: "Ok", style: .default)

        presentAlert(title: "Weather App: Error Catched", message: "Message: \(error)", actions: [action])
    }
}
