import SnapKit
import UIKit

class AppViewController: UIViewController {
    private var logo: UIImageView!
    private var appNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var authorLabel: UILabel!
    private var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        configureLogo()
        configureTitleLabel()
        configureDescription()
        configureAuthorLabel()
        configureVersionLabel()
    }

    func configureLogo() {
        let image = UIImage(systemName: "cloud.sun.fill")?.withRenderingMode(.alwaysOriginal)
        logo = UIImageView(image: image)
        logo.contentMode = .scaleAspectFit
        view.addSubview(logo)

        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp_topMargin)
            make.height.width.equalTo(view.frame.width / 2.0)
        }
    }

    func configureTitleLabel() {
        appNameLabel = UILabel()
        appNameLabel.textColor = .white
        appNameLabel.font = UIFont.systemFont(ofSize: 40)
        appNameLabel.textAlignment = .center

        if let title = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
            appNameLabel.text = title
        } else {
            appNameLabel.text = "Weather app"
        }

        view.addSubview(appNameLabel)

        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logo.snp_bottomMargin).inset(-30)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }

    func configureDescription() {
        guard let description = Bundle.main.object(forInfoDictionaryKey: "App description") as? String else {
            return
        }
        descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.layer.cornerRadius = 10
        descriptionLabel.textAlignment = .justified
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = description

        view.addSubview(descriptionLabel)

        descriptionLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.equalTo(appNameLabel.snp_bottomMargin).inset(-40)
        }
    }

    func configureAuthorLabel() {
        guard let author = Bundle.main.object(forInfoDictionaryKey: "Author") as? String else {
            return
        }
        authorLabel = UILabel()
        authorLabel.textAlignment = .right
        authorLabel.textColor = .white
        authorLabel.numberOfLines = 2
        authorLabel.layer.opacity = 0.5
        authorLabel.font = UIFont.italicSystemFont(ofSize: 15)
        authorLabel.text = "Created by\n\(author)"

        view.addSubview(authorLabel)

        authorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(descriptionLabel.snp_bottomMargin).inset(-30)
        }
    }

    func configureVersionLabel() {
        guard let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return
        }

        versionLabel = UILabel()
        versionLabel.textColor = .black
        versionLabel.textAlignment = .right
        versionLabel.font = UIFont.systemFont(ofSize: 10)
        versionLabel.numberOfLines = 1
        versionLabel.layer.opacity = 0.3
        versionLabel.text = "Version: \(version)"

        view.addSubview(versionLabel)

        versionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp_bottomMargin)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }
}
