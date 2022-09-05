import Foundation

public protocol Storage {
    func fetchList() throws -> [String]
    func save(cities: [String]) throws
}

public struct StorageUserDefaults: Storage {
    private let storage = UserDefaults.standard

    public init() {}

    public func save(cities: [String]) throws {
        storage.set(cities, forKey: Constants.rootIdentifier)
    }

    public func fetchList() -> [String] {
        let cities = storage.object(forKey: Constants.rootIdentifier) as? [String] ?? []
        return cities
    }

    private enum Error: Swift.Error {
        case rootDictionaryMissing
    }
}

private enum Constants {
    static let rootIdentifier = "cities"
}
