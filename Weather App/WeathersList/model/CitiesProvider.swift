import Foundation

class CitiesProvider {
    func fetchCities() async throws -> [City] {
        guard let path = Bundle.main.path(forResource: "city.list", ofType: "json") else {
            return []
        }
        var decoded: [City] = []
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decoder = JSONDecoder()
        decoded = try decoder.decode([City].self, from: data)
        decoded = Array(Set(decoded))

        return decoded
    }
}
