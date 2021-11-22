//
//  Request+Error.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//
import Foundation
public protocol RequestErrorProtocol {
    var localizedKey : String { get }
}
extension RequestErrorProtocol {
    var localizedComment : String {
        return Bundle.main.bundleIdentifier ?? "" + localizedKey
    }
    
    func error( _ language : String = "en") -> String {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        return NSLocalizedString(localizedKey , bundle: bundle, comment: localizedComment)
    }
}
