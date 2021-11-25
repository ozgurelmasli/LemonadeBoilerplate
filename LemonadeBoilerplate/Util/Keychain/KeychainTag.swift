//
//  KeychainTag.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//
import Foundation

public protocol KeychainTag {
    var keychainKey: String { get }
}
extension KeychainTag {
    
    func identifier() -> String {
        return bundle() + keychainKey
    }
    
    func bundle() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }
}

enum AppKeychainTag: KeychainTag {
    var keychainKey: String {
        switch self {
        case .authorization: return "Authorization"
        case .session : return "session"
        case .uuid : return "uui"
        }
    }
    
    case uuid
    case authorization
    case session
}
