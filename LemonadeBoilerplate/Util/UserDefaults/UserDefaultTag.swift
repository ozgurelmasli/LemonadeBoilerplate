//
//  UserDefaultTag.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import Foundation

public protocol UserdefaultsTag : AnyObject {
    var identifier : String { get }
}

extension UserdefaultsTag {
    func buildTag() -> String {
        return Bundle.main.bundleIdentifier ?? "" + identifier
     }
}
