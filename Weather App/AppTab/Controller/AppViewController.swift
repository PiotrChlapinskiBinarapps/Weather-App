import SnapKit
import UIKit

class AppViewController: UIViewController {
    private var logo: UIImageView = {
        let image = UIImage(systemName: "cloud.sun.fill")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var appNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom(.white)
        label.font = Constants.appNameLabelFont
        label.textAlignment = .center
        if let title = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
            label.text = title
        } else {
            label.text = "Weather app"
        }
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom(.white)
        label.layer.cornerRadius = Constants.appDescriptionLabelConrnerRadius
        label.textAlignment = .justified
        label.font = Constants.appDescriptionLabelFont
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = Constants.appDescriptionLabelNumberOfLines
        label.text = Texts.appDescription
        return label
    }()

    private var authorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .custom(.white)
        label.numberOfLines = Constants.authorLabelNumberOfLines
        label.layer.opacity = Constants.authorLabelOpacity
        label.font = Constants.authorLabelFont
        label.text = Texts.author
        return label
    }()

    private var versionLabel: UILabel = {
        guard let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return UILabel()
        }

        let label = UILabel()
        label.textColor = .custom(.white)
        label.textAlignment = .right
        label.font = Constants.versionLabelFont
        label.numberOfLines = Constants.versionLabelNumberOfLines
        label.layer.opacity = Constants.versionLabelOpacity
        label.text = "Version: \(version)"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImage(named: "app_background")
        let backgroundImageView = UIImageView(image: backgroundImage)

        view.addSubview(backgroundImageView)

        configureLogo()
        configuteAppNameLabel()
        configureDescription()
        configureAuthorLabel()
        configureVersionLabel()

        backgroundImageView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }

    func configureLogo() {
        view.addSubview(logo)

        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp_topMargin)
            make.height.width.equalTo(view.frame.width / 2.0)
        }
    }

    func configuteAppNameLabel() {
        view.addSubview(appNameLabel)

        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logo.snp_bottomMargin).inset(Constants.appNameLabelTop)
            make.trailing.leading.equalToSuperview().inset(Constants.appNameLabelTrailingLeading)
        }
    }

    func configureDescription() {
        view.addSubview(descriptionLabel)

        descriptionLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(Constants.appDescriptionLabelTrailingLeading)
            make.top.equalTo(appNameLabel.snp_bottomMargin).inset(Constants.appDescriptionLabelTop)
        }
    }

    func configureAuthorLabel() {
        view.addSubview(authorLabel)

        authorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.authorLabelLeadingTrailing)
            make.top.equalTo(descriptionLabel.snp_bottomMargin).inset(Constants.authorLabelTop)
        }
    }

    func configureVersionLabel() {
        view.addSubview(versionLabel)

        versionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp_bottomMargin)
            make.trailing.leading.equalToSuperview().inset(Constants.versionLabelTrailingLeading)
        }
    }
}

private struct Constants {
    private init() {}

    // MARK: - AppNameLabel's constatns

    static let appNameLabelFont = UIFont.systemFont(ofSize: 40)
    static let appNameLabelTrailingLeading = 16
    static let appNameLabelTop = -30

    // MARK: - AppDescriptionLabel's constants

    static let appDescriptionLabelConrnerRadius: CGFloat = 10
    static let appDescriptionLabelFont = UIFont.systemFont(ofSize: 20)
    static let appDescriptionLabelNumberOfLines = 0
    static let appDescriptionLabelTrailingLeading = 16
    static let appDescriptionLabelTop = -40

    // MARK: - AuthorLabel's Constatns

    static let authorLabelNumberOfLines = 2
    static let authorLabelOpacity: Float = 0.5
    static let authorLabelFont = UIFont.italicSystemFont(ofSize: 15)
    static let authorLabelLeadingTrailing = 16
    static let authorLabelTop = -30

    // MARK: - VersionLabel's constatns

    static let versionLabelNumberOfLines = 1
    static let versionLabelOpacity: Float = 0.3
    static let versionLabelFont = UIFont.systemFont(ofSize: 10)
    static let versionLabelTrailingLeading = 16
}

private struct Texts {
    private init() {}

    // MARK: - Author text

    static let author = "Created by Piotr Chłapiński"

    // MARK: - App description

    static let appDescription = "Weather App is application for checking weather in user's location or selected cities by user. Weather app provides information like humidity, pressure, temperature and short description."
}
