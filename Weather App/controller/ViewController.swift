import CoreLocation
import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var weatherTableView: UITableView!
    private let userLocationViewModel = UserLocationViewModel()
    var weatherForCityViewModel: WeatherForCityViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userLocationViewModel.configureLocationService()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(coordinateChanged),
                                               name: .coordinateChanged,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receivedWeather(_:)),
                                               name: .weatherReturned,
                                               object: nil)
        weatherTableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        weatherTableView.dataSource = self
        weatherTableView.backgroundColor = .white
    }

    @objc func coordinateChanged(_: Notification) {
        guard let coordinate = userLocationViewModel.userLocation.currentLocation else {
            return
        }
        weatherForCityViewModel.getWeatherForCoordinate(coordinate: coordinate)
    }

    @objc func receivedWeather(_ notification: Notification) {
        guard let weather = notification.object as? WeatherForCity else {
            return
        }
        print(weather.mesurements.temperature)

        DispatchQueue.main.async {
            self.weatherTableView.reloadData()
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return weatherForCityViewModel.weathers.count
    }

    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
                as? WeatherCell else {
            return tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        }

        // Configure the cell’s contents.
        print(weatherForCityViewModel.weathers[indexPath.row].name)
        let name = weatherForCityViewModel.weathers[indexPath.row].name
        cell.cityLabel.text = name
        cell.degreeLabel.text = "\(weatherForCityViewModel.weathers[indexPath.row].mesurements.temperature) °C"

        return cell
    }
}
