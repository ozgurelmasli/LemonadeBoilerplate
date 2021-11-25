//
//  ExampleService.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//

enum ExampleService: ServiceRequest {
    case exampleRequest
    
    var credential: RequestCredentials {
        return .init(method: .get, header: nil, body: nil)
    }
    var host: RequestHosts { return .API }
    
    var urlPath: String { return "" }
    
    var service: Service { return .exampleService }
    
    var error: RequestErrorProtocol? { return nil }
}
