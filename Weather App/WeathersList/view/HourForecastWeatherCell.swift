import Foundation
import UIKit

class HourForecastWeatherCell: UICollectionViewCell {
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom(.white)
        label.font.withSize(10)
        return label
    }()

    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "12 C"
        label.textColor = .custom(.white)
        label.font.withSize(10)
        return label
    }()

    private var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.spacing = 10
        return stack
    }()

    private var weatherSymbolImageView: UIImageView = .init(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        backgroundColor = .custom(.gray).withAlphaComponent(0.9)
        layer.cornerRadius = 15
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        [temperatureLabel, weatherSymbolImageView, timeLabel].forEach { mainStack.addArrangedSubview($0) }

        addSubview(mainStack)

        mainStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }

    public func setup(weatherForecast: OneForecast) {
        timeLabel.text = "\(weatherForecast.date.hoursAndMinutes)"
        temperatureLabel.text = "\(weatherForecast.mesurements.temperature.int)°C"

        let image = UIImage(named: "\(weatherForecast.description[0].iconId)")
        weatherSymbolImageView.image = image
    }
}
