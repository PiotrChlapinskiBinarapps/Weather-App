import Foundation
import SnapKit
import UIKit

class WeatherDetailsViewController: UIViewController {
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var sunriseLabel: UILabel!
    @IBOutlet var sunsetLabel: UILabel!
    @IBOutlet var humadityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var cloudinessLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var forecastHoursCollection: UICollectionView!
    @IBOutlet var daysForecastsCollection: UICollectionView!
    private lazy var hoursForecastDataSource = HoursForecastDataSource(weather: weather)
    private lazy var daysForecastDataSource = DaysForecastDataSource(weather: weather)

    var weather: CityWeather!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard weather != nil else {
            fatalError("Bad weather init")
        }
        configureView()
    }

    private func configureView() {
        cityNameLabel.text = weather.name
        temperatureLabel.text = "\(Int(weather.mesurements.temperature)) °C"
        humadityLabel.text = "\(weather.mesurements.humidity)%"
        pressureLabel.text = "\(weather.mesurements.pressure)hPa"
        windSpeedLabel.text = "\(weather.wind.velocity)km/h"
        cloudinessLabel.text = "\(weather.clouds.cloudiness)%"

        sunriseLabel.text = "\(weather.sun.sunrise.hoursAndMinutes)"
        sunsetLabel.text = "\(weather.sun.sunset.hoursAndMinutes)"

        let image = UIImage(named: "\(weather.description[0].iconId)")
        weatherImageView.image = image

        configureCollections()
    }

    private func configureCollections() {
        forecastHoursCollection.register(HourForecastWeatherCell.self, forCellWithReuseIdentifier: "forecastHourCell")
        forecastHoursCollection.dataSource = hoursForecastDataSource

        daysForecastsCollection.register(DayForecastWeatherCell.self, forCellWithReuseIdentifier: "forecastHourCell")
        daysForecastsCollection.dataSource = daysForecastDataSource

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: daysForecastsCollection.frame.width - 30, height: 80)

        daysForecastsCollection.collectionViewLayout = layout
    }
}
