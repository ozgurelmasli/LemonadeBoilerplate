//
//  String+Extensions.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//
import Foundation

extension String {
    var firstWord: String {
        return self.contains(" ") ? self.components(separatedBy: " ").first ?? self : self
    }
    var lastWord: String {
        return self.contains(" ") ? self.components(separatedBy: " ").last ?? self : self
    }
    var whiteSpaceTrimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Localized
    func localized( _ languageIdentifier: String = "tr") -> String {
        let path = Bundle.main.path(forResource: languageIdentifier, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
    func localiedUppercase( _ languageIdentifier: String = "tr") -> String {
        return self.uppercased(with: NSLocale.init(localeIdentifier: "tr") as Locale)
    }
    
    /// Date converter
    func toDate( _ format: String = "MM/dd/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  format
        guard let date = dateFormatter.date(from: self) else { return nil }
        return date
    }
    
}
