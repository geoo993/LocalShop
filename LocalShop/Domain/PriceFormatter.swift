import Foundation

enum PriceFormatter {
    static func money(amount: Double, locale: Locale = .autoupdatingCurrent) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = ","
        formatter.locale = locale
        let number = NSNumber(value: amount)
        return formatter.string(from: number) ?? String(format: "$%.02f", amount)
    }
}
