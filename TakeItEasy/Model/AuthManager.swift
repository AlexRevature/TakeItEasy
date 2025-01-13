//
//  AuthManager.swift
//  TakeItEasy
//
//  Created by Alex Cabrera on 1/10/25.
//

import Foundation

class AuthManager {
    
    private init() {}
    
    static func saveCredentials(username: String, password: String) -> CredentialStatus {
        
        let attributes: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            return .collision
        }
        
        guard status != errSecSuccess else {
            return .failure
        }
        
        return .success
        
    }
    
    static func retrievePassword(username: String) -> (CredentialStatus, String?) {
        let request: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var response: CFTypeRef?
        let status = SecItemCopyMatching(request as CFDictionary, &response)
        
        guard status != errSecInvalidKeyRef else {
            return (.invalidKey, nil)
        }
        
        guard status == noErr else {
            return (.failure, nil)
        }
        
        let data = response as! [String: Any]
        let pwdData = data[kSecValueData as String] as! Data
        let password = String(data: pwdData, encoding: .utf8)
        
        return (.success, password)
    }
    
    static func deleteCredentials() -> CredentialStatus {
            
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrSynchronizable: kSecAttrSynchronizableAny
        ] as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            return .failure
        }
        
        return .success
    }
}

enum CredentialStatus {
    case collision
    case invalidKey
    case success
    case failure
}
