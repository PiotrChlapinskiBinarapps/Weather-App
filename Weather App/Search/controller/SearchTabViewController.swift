import SnapKit
import UIKit

class SearchTabViewController: UIViewController {
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.layer.cornerRadius = 15.0
        searchBar.placeholder = Texts.searchPlaceHolderText
        searchBar.searchBarStyle = .minimal
        let textFieldInsideSearchBar = searchBar.value(forKey: Constants.searchTextFieldKey) as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        return searchBar
    }()

    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: Constants.searchCellIdentifier)
        return tableView
    }()

    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Texts.searchTitleLableText
        titleLabel.textColor = .custom(.white)
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.fontSizeTitle)
        return titleLabel
    }()

    private var cities: [City]!
    private var dataToDispaly: [City]!
    private var citiesProvider: CitiesProvider

    required init?(coder: NSCoder) {
        citiesProvider = CitiesProvider()
        cities = citiesProvider.fetchCities()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom(.black)

        dataToDispaly = cities

        configureView()
    }
}

extension SearchTabViewController {
    private func configureSearchBar() {
        searchBar.delegate = self
        view.addSubview(searchBar)

        searchBar.snp.makeConstraints { make in
            make.height.equalTo(Constants.searchBarHight)
            make.leading.trailing.equalToSuperview().inset(Constants.searchBarLeadingTrailing)
            make.top.equalTo(titleLabel.snp_bottomMargin).inset(Constants.searchBarTop)
        }
    }

    private func configureTable() {
        tableView.dataSource = self
        tableView.delegate = self
        // We need set color for table view background here, because in init this variable is set color on white
        tableView.backgroundColor = .app(.primary)

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.leading.right.equalToSuperview().inset(Constants.tableViewLeadingTrailing)
            make.top.equalTo(searchBar.snp_bottomMargin).inset(Constants.tableViewTop)
            make.bottom.equalTo(view.snp_bottomMargin)
        }
    }

    func configureView() {
        view.addSubview(titleLabel)

        configureSearchBar()
        configureTable()

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.titleLabelLeadingTrailing)
            make.top.equalTo(view.snp_topMargin)
        }
    }
}

extension SearchTabViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchCellIdentifier, for: indexPath) as? SearchViewCell else {
            return UITableViewCell()
        }
        cell.cityName.text = dataToDispaly[indexPath.row].name
        cell.countryName.text = dataToDispaly[indexPath.row].country
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return dataToDispaly.count
    }
}

extension SearchTabViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = tabBarController?.viewControllers?[0] as? WeathersListViewController else {
            return
        }

        viewController.addCity(dataToDispaly[indexPath.row])
        tabBarController?.selectedIndex = 0
    }
}

extension SearchTabViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        dataToDispaly = searchText.isEmpty ? cities : cities.filter { (item: City) -> Bool in
            item.name.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive], range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
}

private struct Constants {
    private init() {}

    static let fontSizeTitle: CGFloat = 30

    // MARK: - TableView's Constants

    static let tableViewLeadingTrailing: CGFloat = -10
    static let tableViewTop = -10

    // MARK: - SearchBar's Constants

    static let searchCellIdentifier = "searchCell"
    static let searchTextFieldKey = "searchField"
    static let searchBarHight: Int = 60
    static let searchBarLeadingTrailing = 10
    static let searchBarTop = -10

    // MARK: - Title Label's Constants

    static let titleLabelLeadingTrailing = 16
}

private struct Texts {
    private init() {}

    // MARK: - SearchTabViewController's texts

    static let searchPlaceHolderText = "SearchCity"
    static let searchTitleLableText = "Search Location"
}
