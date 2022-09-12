import Foundation

public extension DateFormatter {
    static let shortTimeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        timeFormatter.dateFormat = "HH:mm"

        return timeFormatter
    }()

    static let shortDateFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        timeFormatter.dateFormat = "yyyy-MM-dd"

        return timeFormatter
    }()

    static let simpleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        formatter.locale = Locale(identifier: "en_us")

        return formatter
    }()
}
