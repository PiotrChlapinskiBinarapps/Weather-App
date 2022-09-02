import Foundation
import UIKit

struct Constants {
    private init() {}

    static let fontSizeTitle: CGFloat = 30

    // MARK: - TableView's Constants

    static let tableViewLeadingTrailing: CGFloat = -10
    static let tableViewTop = -10

    // MARK: - ButtonStackView's Constants

    static let buttonStackViewSpacing: CGFloat = 8

    // MARK: - SearchBar's Constants

    static let searchCellIdentifier = "searchCell"
    static let searchTextFieldKey = "searchField"
    static let searchBarHight: Int = 60
    static let searchBarLeadingTrailing = 10
    static let searchBarTop = -10

    // MARK: - Title Label's Constants

    static let titleLabelLeadingTrailing = 16

    // MARK: - Search View Cell's Constants

    static let cityLabelFont = UIFont.boldSystemFont(ofSize: 15)
    static let countryLabelFont = UIFont.systemFont(ofSize: 13)
    static let mainStackSpacing: CGFloat = 4
    static let cellBorderWidth: CGFloat = 2
    static let cellCornernRadius: CGFloat = 8
    static let mainStackViewLeadingTrailing = 16
    static let mainStackViewTopBottom = 10
}

struct Texts {
    private init() {}

    // MARK: - SearchTabViewController's texts

    static let searchPlaceHolderText = "SearchCity"
    static let searchTitleLableText = "Search Location"
}
