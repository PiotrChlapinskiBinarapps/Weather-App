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
    @IBOutlet var backgroundImageView: UIImageView!
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
        let temperature = Measurement(value: weather.mesurements.temperature, unit: UnitTemperature.celsius)
        let pressure = Measurement(value: weather.mesurements.pressure, unit: UnitPressure.hectopascals)
        let velocity = Measurement(value: weather.wind.velocity, unit: UnitSpeed.kilometersPerHour)
        let humidity = Measurement(value: weather.mesurements.humidity, unit: Unit.percent)
        let cloudiness = Measurement(value: weather.clouds.cloudiness, unit: Unit.percent)

        temperatureLabel.text = temperature.withoutDigits
        windSpeedLabel.text = velocity.withoutDigits
        pressureLabel.text = pressure.withoutDigits
        humadityLabel.text = humidity.withoutDigits
        cloudinessLabel.text = cloudiness.withoutDigits

        sunriseLabel.text = "\(weather.sun.sunrise.hoursAndMinutes)"
        sunsetLabel.text = "\(weather.sun.sunset.hoursAndMinutes)"

        let image = UIImage(named: "\(weather.description[0].iconId)")
        weatherImageView.image = image

        let background = UIImage(named: "\(weather.description[0].iconId)b")
        backgroundImageView.image = background

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
