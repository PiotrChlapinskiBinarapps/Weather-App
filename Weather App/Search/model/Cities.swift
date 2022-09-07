import Foundation

public struct City: Codable, Hashable {
    let name: String
    let country: String
    let plainName: String

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        country = try values.decode(String.self, forKey: .country)
        plainName = name.removeDiacratics()
    }
}

public struct Cities {
    var items: [City]

    public func isNotContainedCity(cityName: String) -> Bool {
        let isContained = items.contains {
            $0.plainName == cityName
        }
        return !isContained
    }
}
