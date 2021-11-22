//
//  ExampleService.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//

enum ExampleServic : ServiceRequest {
    var credential:RequestCredentials {
        return .init(method: .get
                     , header: nil
                     , body: nil)
    }
    var host: RequestHosts { return .API }
    
    var urlPath: String { return "" }
    
    var service: Service { return .ExampleService }
    
    var error: RequestErrorProtocol? { return nil }
}
