//
//  Interceptor.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//

import Alamofire

class Interceptor : InterceptorBase {
    func configureRequest(_ request: URLRequest, session: Session, addedParams: [InterceptorCredentialBuilder]) {
        
    }
    
    func unexpectedErrorCodeOnRetry(_ request: Request, session: Session, _ error: Error, statusCode: Int) {
        
    }
    
    func undecodedDataOnRetry(_ request: Request, session: Session, data: Data?) {
        
    }
    
    func willRetry(_ request: Request, session: Session, responseData: InterceptorResponseModel, possibleErrors: [InterceptorErrorProtocol], remainingRetryCount: Int) {
        
    }
    
    func retryLimitExceeded(_ request: Request, session: Session, responseData: InterceptorResponseModel, possibleErrors: [InterceptorErrorProtocol]) {
        
    }
    
    typealias T = InterceptorResponseModel
    
}
