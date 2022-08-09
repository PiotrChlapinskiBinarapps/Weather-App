import Foundation
import UIKit

class WeatherDetailsViewController: UIViewController {
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    var weather: WeatherForCity?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let weather = weather else {
            return
        }
        cityNameLabel.text = weather.name
        temperatureLabel.text = "\(weather.mesurements.temperature) °C"
        pressureLabel.text = "\(weather.mesurements.pressure) hPa"
        humidityLabel.text = "\(weather.mesurements.humidity) %"
        weatherDescriptionLabel.text = "\(weather.description[0].descriptionWeather)"
    }
}
