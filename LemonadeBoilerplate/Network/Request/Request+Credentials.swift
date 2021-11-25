//
//  Request+Credentials.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//
import Alamofire

public struct RequestCredentials {
    var header: HTTPHeaders?
    var body: Parameters?
    var method: HTTPMethod
    
    public init(method: HTTPMethod, header: HTTPHeaders?, body: Parameters?) {
        self.method = method
        self.header = header
        self.body = body
    }
}

public enum Service: String {
    case exampleService = "example-service"
}
