import CoreLocation
import UIKit

class ViewController: UIViewController {
    @IBOutlet var weatherTableView: UITableView!
    private let userLocationViewModel = UserLocationViewModelImpl()
    var weatherForCityViewModel: WeatherForCityViewModel = WeatherForCityViewModelImpl()

    override func viewDidLoad() {
        super.viewDidLoad()

        userLocationViewModel.configureLocationService()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(coordinateChanged),
                                               name: .coordinateChanged,
                                               object: nil)

        weatherTableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        weatherTableView.dataSource = self
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
}

extension ViewController: UITableViewDataSource {
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
