import Foundation

class CitiesProvider {
    func fetchCities() -> [City] {
        guard let path = Bundle.main.path(forResource: "city.list", ofType: "json") else {
            return []
        }
        var decoded: [City] = []
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            decoded = try decoder.decode([City].self, from: data)
            decoded = Array(Set(decoded))
            decoded = decoded.sorted { $0.name.lowercased() < $1.name.lowercased() }
        } catch {
            // Error Handler
            print(error)
        }

        return decoded
    }
}
