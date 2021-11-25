//
//  Date+Extensions.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import Foundation

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    func localized( _ localeIdentifier: String = "tr_TR") -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = NSLocale(localeIdentifier: localeIdentifier) as Locale
        return calendar
    }
    func compare(with date: Date, condition: Calendar.Component) -> ComparisonResult {
        let result = Calendar.current.compare(self, to: date, toGranularity: condition)
        return result
    }
    func string(dateFormat: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}
