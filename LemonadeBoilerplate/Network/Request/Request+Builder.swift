//
//  Request+Builder.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//

import Foundation

public enum RequestHosts : String {
    case API = "api"
    case AUTH = "auth"
    case STATIC = "static"
}


public struct RequestURLBuilder {
    var host  : RequestHosts
    var domain : String
    
    public init(host : RequestHosts , domain : String) {
        self.host = host
        self.domain = domain
    }
    
    
    func build() -> String {
        return host.rawValue + domain
    }
}
