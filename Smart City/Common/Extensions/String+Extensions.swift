//
//  String+Extensions.swift
//  Smart City
//
//  Created by Lugardo on 29/06/25.
//
import Foundation

extension String {
    var countryName: String? {
        Locale.current.localizedString(forRegionCode: self.uppercased())
    }
    
    var flagEmoji: String {
        guard self.count == 2, self.range(of: #"^[A-Za-z]{2}$"#, options: .regularExpression) != nil else {
            return ""
        }
        
        return self.uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(127397 + $0.value) }
            .map { String($0) }.joined()
    }
}
