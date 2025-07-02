//
//  String+Extensions.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import Foundation

extension String {
    var countryName: String? {
        Locale.current.localizedString(forRegionCode: uppercased())
    }

    var flagEmoji: String {
        guard count == 2, range(of: #"^[A-Za-z]{2}$"#, options: .regularExpression) != nil else {
            return ""
        }

        return uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(127_397 + $0.value) }
            .map { String($0) }.joined()
    }
}

extension String {
    func toDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        let date = dateFormatter.date(from: self) ?? Date.now
        return date
    }
}
