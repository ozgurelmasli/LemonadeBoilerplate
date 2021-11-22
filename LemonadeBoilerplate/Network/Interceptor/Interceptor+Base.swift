//
//  Interceptor+Base.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//

import Alamofire

public protocol InterceptorBaseProtocol : AnyObject {}

public protocol InterceptorBase : Alamofire.RequestInterceptor , InterceptorBaseProtocol {
    
    associatedtype T : Codable
    
    func configureRequest( _ request : URLRequest , session : Session , addedParams : [InterceptorCredentialBuilder])
    func unexpectedErrorCodeOnRetry( _ request : Request , session : Session , _ error : Error , statusCode : Int)
    func undecodedDataOnRetry( _ request : Request , session : Session , data : Data?)
    func willRetry( _ request : Request , session : Session , responseData : T , possibleErrors : [InterceptorErrorProtocol] , remainingRetryCount : Int)
    func retryLimitExceeded( _ request : Request , session : Session , responseData : T , possibleErrors : [InterceptorErrorProtocol])
}



extension InterceptorBase {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
         let credentialConfigs = NetworkConnection.shared.interceptorCredentials
        
        if credentialConfigs.isEmpty { completion(.success(urlRequest)) }
        
        var urlRequest = urlRequest
        for config in credentialConfigs {
            if config.keychainTag != nil {
                guard
                    let data = try? KeychainStore.shared.load(tag: config.keychainTag!)
                    , let string = KeychainStore.shared.convertToString(data: data)
                else { return }
                urlRequest.setValue(config.tokenPrefix == nil ? string : config.tokenPrefix! + string, forHTTPHeaderField: config.identifier)
            }
            if config.userDefaultKey != nil {
                guard let string = UserDefaults.standard.get(String.self, tag: config.userDefaultKey!) else { return }
                urlRequest.setValue(config.tokenPrefix == nil ? string : config.tokenPrefix! + string, forHTTPHeaderField: config.identifier)
            }
        }
        
        self.configureRequest(urlRequest, session: session, addedParams: credentialConfigs)
        
        completion(.success(urlRequest))
    }
    func retry( _ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let possibleStatusCodes = NetworkConnection.shared.interceptorPossibleRetryStatusCodes
        if possibleStatusCodes.isEmpty { completion(.doNotRetryWithError(error)) }
        guard let response = request.task?.response as? HTTPURLResponse , possibleStatusCodes.contains(response.statusCode) else {
            self.unexpectedErrorCodeOnRetry(request, session: session, error, statusCode: (request.task?.response as? HTTPURLResponse)?.statusCode ?? 404)
            return completion(.doNotRetryWithError(error))
        }
        let decoder = JSONDecoder()
        guard
            let request         = request as? DataRequest
            , let data          = request.data
            , let decodedModel  =  try? decoder.decode(T.self, from: data)
        else {
            self.undecodedDataOnRetry(request, session: session , data: (request as? DataRequest)?.data)
            return completion(.doNotRetryWithError(error))
        }
        if request.retryCount < NetworkConnection.shared.interceptorRetryLimit {
            self.willRetry(request
                           , session: session
                           , responseData: decodedModel
                           , possibleErrors: NetworkConnection.shared.interceptorPossibleRetryErrors
                           , remainingRetryCount: NetworkConnection.shared.interceptorRetryLimit - request.retryCount)
            return completion(.retry)
        }else {
            self.retryLimitExceeded(request, session: session, responseData: decodedModel, possibleErrors: NetworkConnection.shared.interceptorPossibleRetryErrors)
            return completion(.doNotRetry)
        }
        
    }
}
