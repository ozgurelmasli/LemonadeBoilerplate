//
//  Interceptor+Error.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//
import Alamofire

public protocol InterceptorErrorProtocol {
    var errorMessage : String { get }
    var statusCode   : Int { get }
    var isRetryable  : RetryResult { get }
}
