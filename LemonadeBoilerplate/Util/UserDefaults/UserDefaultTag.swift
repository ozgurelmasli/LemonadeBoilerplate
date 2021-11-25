//
//  UserDefaultTag.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import Foundation

protocol UserdefaultsTag {
    var identifier: String { get }
}

extension UserdefaultsTag {
    func buildTag() -> String {
        return Bundle.main.bundleIdentifier ?? "" + identifier
     }
}

enum DeepLinkTag: UserdefaultsTag {
    case hasDeepLink
    
    var identifier: String {
        return "hasDeepLink"
    }
}
