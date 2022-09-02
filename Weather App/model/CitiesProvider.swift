import Foundation

class CitiesProvider {
    func fetchCities() -> [City] {
        guard let path = Bundle.main.path(forResource: "city.list", ofType: "json") else {
            return []
        }
        var cities: [City] = []
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(CitiesRepository.self, from: data)
            cities = decoded.cities
            cities = Array(Set(cities))
            cities = cities.sorted { $0.name.lowercased() < $1.name.lowercased() }
        } catch {
            // Error Handler
            print(error)
        }

        return cities
    }
}
