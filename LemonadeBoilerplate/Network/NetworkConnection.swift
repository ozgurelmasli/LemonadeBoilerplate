//
//  NetworkConnection.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//
import Alamofire

internal class NetworkConnection {
    private static var referance: NetworkConnection? = NetworkConnection()
    
    public static var shared: NetworkConnection {
        if referance == nil { referance  = NetworkConnection() }
        return referance!
    }
    
    var baseURL: RequestURLBuilder = .init(host: .API, domain: "DOMAIN-NAME")
    var authURL: RequestURLBuilder = .init(host: .AUTH, domain: "DOMAIN-NAME")
    var staticURL: RequestURLBuilder = .init(host: .STATIC, domain: "DOMAIN-NAME")
    
    var timeOut: TimeInterval = 30
    var cache: NSURLRequest.CachePolicy = .reloadIgnoringCacheData
    var allowCelluarAccess: Bool = true
    var isServiceLoggerEnabled: Bool = true
    
    var interceptorPossibleRetryStatusCodes: [Int] = [401]
    var interceptorRetryLimit: Int = 5
    var interceptorRetryDelay: TimeInterval = 10
    var interceptorPossibleRetryErrors: [InterceptorErrorProtocol] = []
    
    var interceptorCredentials: [InterceptorCredentialBuilder] = [
        .init(identifier: "uuid", keychainTag: AppKeychainTag.uuid),
        .init(identifier: "Authorization", tokenType: "Bearer ", keychainTag: AppKeychainTag.authorization),
        .init(identifier: "session", tokenType: "Bearer ", keychainTag: AppKeychainTag.session)
    ]
    
    internal var sessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = timeOut
        configuration.allowsCellularAccess = allowCelluarAccess
        configuration.requestCachePolicy = cache
        return configuration
    }
    internal var sessionTrustManager: ServerTrustManager {
        return .init(allHostsMustBeEvaluated: false, evaluators: [
            baseURL.build(): DisabledTrustEvaluator(),
            authURL.build(): DisabledTrustEvaluator(),
            staticURL.build(): DisabledTrustEvaluator()
        ])
    }
    internal var interceptor: InterceptorBaseProtocol {
        return Interceptor()
    }
}
func serviceLogger(message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
    print(" 🤨 Service Log : Message : \(message.isEmpty ? "Logger from" : message) , File : \(file)  called from : \(function) , line number : \(line) 🤨")
}
