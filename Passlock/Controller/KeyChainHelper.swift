//
//  KeyChainHelper.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/11.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation
import Valet
import CryptoKit

public class KeyChainHelper{
    
    // Init Biometric SecureEnclave of Keychain Access with Valet framework
    static let BiometricValet = SecureEnclaveValet.valet(with: Identifier(nonEmpty: "Main")!, accessControl: .biometricAny)
    
    // Init  SecureEnclave of Keychain Access with Valet framework
    static let valet = Valet.valet(with: Identifier(nonEmpty: "Main")!, accessibility: .whenUnlocked)
    
    
    // - Function: Writing salt of hashing operations to the SecureEnclave.
    func storeSalties(data: String)
    {
        // Convert String to Data type with UTF8 encoding
        let data = data.data(using: .utf8)!
        // Hashing data with SHA512
        let hash = SHA512.hash(data: data)
        // Converting hash to string
        let key = hash.map { String(format: "%02hhx", $0) }.joined()
        // Set Key
        KeyChainHelper.BiometricValet.set(string: key, forKey: "IOSVersion")
    }
    
    // - Function: Retrieving salt of hashing operations from the SecureEnclave.
    func retrieveSalties() -> String
    {
        //var key = KeyChainHelper.BiometricValet.string(forKey: "IOSVersion", withPrompt: "Retrieving encrpytion key")
        let keyy = KeyChainHelper.valet.string(forKey: "IOSVersion")
        //print(key)
        return keyy!
    }
}
