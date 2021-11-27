//
//  Request.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 27.11.2021.
//


enum IAPService : ServiceRequest {
    var credential: RequestCredentials {
        return .init(method: .post
                     , header: nil
                     , body: nil)
    }
    case purchase
    
    var host: RequestHosts {
        return .API
    }
    
    var urlPath: String {
        return ""
    }
    
    var service: Service {
        return .purchaseService
    }
    
    var error: RequestErrorProtocol? {
        return nil
    }
}
