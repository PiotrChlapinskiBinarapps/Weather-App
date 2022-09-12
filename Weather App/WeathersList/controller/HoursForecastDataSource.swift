import Foundation
import UIKit

class HoursForecastDataSource: NSObject, UICollectionViewDataSource {
    private let weather: CityWeather

    init(weather: CityWeather) {
        self.weather = weather
        super.init()
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return weather.weatherForecast?.fetchForecastTodayAndNextDay(weather.date).count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastHourCell", for: indexPath) as? HourForecastWeatherCell, let forecasts = weather.weatherForecast?.list[indexPath.row] else {
            fatalError("Dequeued cell has incorrect type")
        }
        cell.setup(weatherForecast: forecasts)

        return cell
    }
}
