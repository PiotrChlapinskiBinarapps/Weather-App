import Foundation
import UIKit

class DaysForecastDataSource: NSObject, UICollectionViewDataSource {
    private let forecast: [OneForecast]

    init(weather: CityWeather) {
        forecast = weather.weatherForecast?.fetchForecastForNextDays() ?? []
        super.init()
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return forecast.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastHourCell", for: indexPath) as? DayForecastWeatherCell else {
            fatalError("Dequeued cell has incorrect type")
        }
        cell.setup(weatherForecast: forecast[indexPath.row])

        return cell
    }
}
