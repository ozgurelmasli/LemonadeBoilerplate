//
//  AuthenticationValidation.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import Foundation
 
protocol AuthenticationValidationProtocol {
    func emailValidation( _ email : String) -> Bool
    func passwordValidation( _ password : String) -> Bool
}

class AuthenticationValidation : AuthenticationValidationProtocol {
    func emailValidation(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    func passwordValidation(_ password: String) -> Bool {
        return !(password.isEmpty || password.count < 8)
    }
}
