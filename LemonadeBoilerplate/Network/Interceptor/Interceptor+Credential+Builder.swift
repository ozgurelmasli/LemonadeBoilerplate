//
//  Interceptor+Credential+Buidler.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//
struct InterceptorCredentialBuilder {
    var identifier : String
    var tokenPrefix : String?
    var keychainTag : KeychainTag?
    var userDefaultKey : UserdefaultsTag?
    
    init( identifier : String , tokenType : String? = nil, keychainTag : KeychainTag) {
        self.identifier = identifier
        self.tokenPrefix = tokenType
        self.keychainTag = keychainTag
        self.userDefaultKey = nil
    }
    init( identifier : String , tokenType : String? = nil , userdefaultTag : UserdefaultsTag) {
       self.identifier = identifier
       self.tokenPrefix = tokenType
       self.keychainTag = nil
       self.userDefaultKey = userdefaultTag
   }
}
