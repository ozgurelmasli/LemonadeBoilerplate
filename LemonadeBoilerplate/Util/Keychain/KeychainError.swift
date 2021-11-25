//
//  KeychainError.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//
enum KeychainError: String, Error {
    case WRITE_ERROR  = "Keychain couldn't write data."
    case DELETE_ERROR = "Keychain couldn't delete data from keychain."
    case READ_ERROR   = "Keychain couldn't read data from keychain."
}
