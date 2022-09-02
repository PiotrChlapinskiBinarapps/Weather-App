import Foundation

struct City: Decodable, Hashable {
    let name: String
    let country: String
}

struct CitiesRepository: Decodable, Hashable {
    var cities: [City]
}
