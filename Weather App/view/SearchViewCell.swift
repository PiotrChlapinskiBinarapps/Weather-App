import Foundation
import UIKit

class SearchViewCell: UITableViewCell {
    var cityName: UILabel = {
        let cityName = UILabel()
        cityName.textColor = .custom(.white)
        cityName.font = Constants.cityLabelFont
        return cityName
    }()

    var countryName: UILabel = {
        let countryName = UILabel()
        countryName.textColor = .custom(.transparentWhite)
        countryName.font = Constants.countryLabelFont
        return countryName
    }()

    private var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .leading
        mainStackView.distribution = .equalCentering
        mainStackView.spacing = Constants.mainStackSpacing
        mainStackView.isLayoutMarginsRelativeArrangement = true
        return mainStackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView() {
        selectionStyle = .none
        backgroundColor = .custom(.gray)
        layer.borderWidth = Constants.cellBorderWidth
        layer.cornerRadius = Constants.cellCornernRadius
        clipsToBounds = true

        configureMainStack()
    }

    func configureMainStack() {
        [cityName, countryName].forEach { mainStackView.addArrangedSubview($0) }

        addSubview(mainStackView)

        mainStackView.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview().inset(Constants.mainStackViewTopBottom)
            make.leading.trailing.equalToSuperview().offset(Constants.mainStackViewLeadingTrailing)
        }
    }
}
