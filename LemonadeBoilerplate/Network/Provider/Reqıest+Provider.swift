//
//  Reqıest+Provider.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//
import Alamofire

public enum ProviderError : Error , Equatable {
    /// Unknown error
    case SOMETHING_WENT_WRONG
    /// URL is not valid
    case URL_ERROR
    /// Device has no internet connection
    case NO_INTERNET_CONNECTION
    /// Custom error type with message
    case CUSTOM(message : String)
}

fileprivate let SessionManager : Session  = {
    return .init(configuration: NetworkConnection.shared.sessionConfiguration
                 , interceptor: (NetworkConnection.shared.interceptor as! RequestInterceptor)
                 , serverTrustManager: NetworkConnection.shared.sessionTrustManager)
}()

public protocol ProviderProtocol : AnyObject {
    var isNetworkReachable : Bool { get }
    
    associatedtype R : ServiceRequest
    
    /**
     Network Request Function
     
     - parameter request: Network request type.
     - parameter decode : Codable JSON model type.
     - returns: complitionHandler(Codable , ProviderError)
     - warning: Async operation , background thread
     
     
     # Notes: #
     1. Don't forget change thread when you are updating UI elements after request
     
     # Example #
     ```
     // provider?.request(.request , Codable.self, complitionHandler) { ... }
     ```
     
     */
    func request<D>( _ request : R
                     , decoding : D.Type
                     , queue : DispatchQueue , responseHandler : @escaping (Result<D , ProviderError>)->Void) where D : Decodable , D: Encodable
}

public class RequestProvider<S : ServiceRequest> : ProviderProtocol {
    public var isNetworkReachable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    public init() {}
    
    public func request<D>( _ service : S
                            , decoding : D.Type
                            , queue : DispatchQueue = .init(label: Bundle.main.bundleIdentifier ?? "", qos: .background, target: .main)
                            , responseHandler : @escaping (Result<D, ProviderError>)-> Void) where D : Decodable, D : Encodable {
        guard let url = URL(string: service.buildURL()) else {
            responseHandler(.failure(.URL_ERROR))
            return
        }
        if !isNetworkReachable {
            responseHandler(.failure(.NO_INTERNET_CONNECTION))
            return
        }
        let request = SessionManager.request(url
                                             , method: service.credential.method
                                             , parameters: service.credential.body
                                             , encoding: (service.credential.body != nil && service.credential.method == .get) ? URLEncoding.httpBody : URLEncoding.default
                                             , headers: service.credential.header)
        request.validate(statusCode: 200...399).responseDecodable(of: D.self
                                                                  , queue: queue) { response in
            if let statusCode = response.response?.statusCode {
                if NetworkConnection.shared.isServiceLoggerEnabled {
                    serviceLogger("Request URL : \(url) , statusCode : \(statusCode) , duration : \(String(describing: response.metrics?.taskInterval.duration))")
                }
            }
            if let err = response.error {
                responseHandler(.failure(.CUSTOM(message: err.localizedDescription)))
                return
            }
            if let data = response.value {
                responseHandler(.success(data))
            }
        }
    }
}
