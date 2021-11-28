//
//  KeychainStore.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//
import Foundation

public class KeychainStore {
    private static var referance: KeychainStore? = KeychainStore()
    
    public static var shared: KeychainStore {
        if referance == nil { referance  = KeychainStore() }
        return referance!
    }
    
    public func add(data: Data, tag: KeychainTag) throws {
        let query = [
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: tag.identifier(),
            kSecValueData as String: data ] as [AnyHashable: Any]
        SecItemDelete(query as CFDictionary)
        
        var result: CFTypeRef?
        let status = SecItemAdd(query as CFDictionary, &result)
        
        if status == errSecSuccess { print("Data saved to keychain") } else {
            if let err: String = SecCopyErrorMessageString(status, nil) as String? {
                print(err)
            }
            throw KeychainError.WRITE_ERROR
        }
    }
    
    public func delete(tag: KeychainTag) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: tag.identifier()
        ]
        SecItemDelete(query as CFDictionary)
        print("Data has been deleted from keychain")
    }
    
    public func load(tag: KeychainTag) throws -> Data {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tag.identifier(),
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne ] as [String: Any]
        
        var dataTypeRef: AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr, let data = dataTypeRef as? Data {
            return data
        } else {
            throw KeychainError.READ_ERROR
        }
    }
}
extension KeychainStore {
    /// Converter String -> Data
    public func convertToData(string: String) -> Data? {
        return string.data(using: .utf8)
    }
    /// Converter Data -> String
    public func convertToString(data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }
}
