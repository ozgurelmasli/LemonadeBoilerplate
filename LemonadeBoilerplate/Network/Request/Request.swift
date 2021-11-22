//
//  Request.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//

public protocol ServiceRequest {
    var credential : RequestCredentials { get }
    var host   : RequestHosts { get }
    var urlPath : String { get }
    var service : Service { get }
    var error : RequestErrorProtocol? { get }
}

extension ServiceRequest {
    func buildURL() -> String {
        let baseURL : String = host == .API
        ? NetworkConnection.shared.baseURL.build()
        : host == .AUTH
        ? NetworkConnection.shared.authURL.build()
        : NetworkConnection.shared.staticURL.build()
        if baseURL == "" { fatalError("Base URL can't be empty.That's illegal") }
        return baseURL + service.rawValue + urlPath
    }
}
