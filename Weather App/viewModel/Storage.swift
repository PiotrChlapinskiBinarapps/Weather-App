import Foundation

/// Protocol  for saving and fetching City objects
public protocol Storage {
    /// Return list of City objects
    func fetchList() throws -> [City]

    /// Save given list of City objects
    /// - Parameters:
    ///   - cities: List of City to saved.
    func save(cities: [City]) throws
}

public struct StorageUserDefaults: Storage {
    private let storage = UserDefaults.standard

    public init() {}

    public func save(cities: [City]) throws {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(cities) else {
            return
        }

        storage.set(encoded, forKey: Constants.rootIdentifier)
    }

    public func fetchList() -> [City] {
        let decoder = JSONDecoder()
        guard let savedCities = storage.object(forKey: Constants.rootIdentifier) as? Data, let loadedCities = try? decoder.decode([City].self, from: savedCities) else {
            return []
        }
        return loadedCities
    }

    private enum Error: Swift.Error {
        case rootDictionaryMissing
    }
}

private enum Constants {
    static let rootIdentifier = "cities"
}
