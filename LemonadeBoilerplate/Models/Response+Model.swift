//
//  Response+Model.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

struct ErrorModel: Codable {
    var errorCode: Int
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "errorCode"
        case message
    }
}
struct ResponseModel<D: Codable>: Codable {
    var statusCode: Int
    var data: D?
    var error: ErrorModel?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case data
        case error
    }
}
