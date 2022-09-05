import Foundation
import UIKit

final class WeatherCell: UITableViewCell {
    @IBOutlet var degreeLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.borderWidth = Constants.cellBorderWidth
        layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        layer.cornerRadius = Constants.cellCornernRadius
        backgroundColor = .custom(.gray).withAlphaComponent(0.7)
        selectionStyle = .none
    }
}

private struct Constants {
    private init() {}

    // MARK: - CityLabel's Font

    static let cityLabelFont = UIFont.boldSystemFont(ofSize: 15)

    // MARK: CountryLabel's Font

    static let countryLabelFont = UIFont.systemFont(ofSize: 13)

    // MARK: MainStack's constants

    static let mainStackSpacing: CGFloat = 4
    static let mainStackViewLeadingTrailing = 16
    static let mainStackViewTopBottom = 10

    // MARK: Cell's constants

    static let cellBorderWidth: CGFloat = 5
    static let cellCornernRadius: CGFloat = 8
}
