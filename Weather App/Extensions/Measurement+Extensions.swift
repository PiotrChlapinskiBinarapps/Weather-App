import Foundation

extension Measurement {
    var withoutDigits: String {
        let formatter = MeasurementFormatter.shortSimplyFormatter
        return formatter.string(from: self)
    }
}
