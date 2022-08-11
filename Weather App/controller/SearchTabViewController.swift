import SnapKit
import UIKit

class SearchTabViewController: UIViewController {
    private var searchTextField: UISearchBar!
    private var tableView: UITableView!
    private let cities = ["Łódź", "Warszawa", "Kraków", "Wrocław", "Gdańsk", "Gdynia", "Bydgoszcz", "Sopot", "Kielce"]
    private var dataToDispaly: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan

        dataToDispaly = cities

        configureTextField()
        configureTable()
    }
}

extension SearchTabViewController {
    private func configureTextField() {
        searchTextField = UISearchBar()
        searchTextField.barTintColor = .systemCyan
        searchTextField.layer.cornerRadius = 15.0
        searchTextField.placeholder = "Search City"
        searchTextField.searchBarStyle = .minimal
        searchTextField.delegate = self

        view.addSubview(searchTextField)

        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.snp_topMargin)
        }
    }

    private func configureTable() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemCyan
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.leading.right.equalToSuperview().inset(5)
            make.top.equalTo(searchTextField.snp_bottomMargin).inset(-30)
            make.bottom.equalTo(view.snp_bottomMargin).inset(10)
        }
    }
}

extension SearchTabViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataToDispaly[indexPath.row]
        cell.backgroundColor = .systemGray2
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return dataToDispaly.count
    }
}

extension SearchTabViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = tabBarController?.viewControllers?[0] as? ViewController else {
            return
        }

        viewController.addCity(name: dataToDispaly[indexPath.row])
        tabBarController?.selectedIndex = 0
    }
}

extension SearchTabViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        dataToDispaly = searchText.isEmpty ? cities : cities.filter { (item: String) -> Bool in
            item.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive], range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
}
