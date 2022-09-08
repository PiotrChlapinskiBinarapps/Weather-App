import Foundation

extension Date {
    var dayAndMonth: String {
        let dateFormatter = DateFormatter.simpleDateFormatter
        return dateFormatter.string(from: self)
    }

    var hoursAndMinutes: String {
        let dateFormatter = DateFormatter.shortTimeFormatter
        return dateFormatter.string(from: self)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
