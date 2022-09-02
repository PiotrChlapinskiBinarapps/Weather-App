import Foundation

extension String {
    func removeDiacratics() -> String {
        return folding(options: .diacriticInsensitive, locale: Locale(identifier: "en_us")).lowercased().replacingOccurrences(of: "ł", with: "l")
    }
}
