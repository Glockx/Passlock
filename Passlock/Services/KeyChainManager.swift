//
//  KeyChainHelper.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/11.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import CryptoKit
import Foundation
import Valet

public class KeyChainManager {
    // Init Biometric SecureEnclave of Keychain Access with Valet framework
    static let BiometricValet = SinglePromptSecureEnclaveValet.valet(with: Identifier(nonEmpty: "Main")!, accessControl: .userPresence)

    // Init  SecureEnclave of Keychain Access with Valet framework
    static let valet = Valet.valet(with: Identifier(nonEmpty: "Main")!, accessibility: .whenUnlocked)

    // - Function: Writing salt of hashing operations to the SecureEnclave.
    func storeKey(data: String) {
        // Set Key
        KeyChainManager.valet.set(string: data, forKey: "Version")
    }

    // - Function: Retrieving salt of hashing operations from the SecureEnclave.
    func retrieveKey() -> String {
        let key = KeyChainManager.valet.string(forKey: "Version")
        return key!
    }

    // MARK: Biometric Functions

    // - Function: Writing masterKey of DB to the SecureEnclave with Biometric Validation.
    func storeKeyBioMetric(data: String)
    {
        // Force require to prompt the user on the next data retrieval
        KeyChainManager.BiometricValet.requirePromptOnNextAccess()
        // Set Key
        KeyChainManager.BiometricValet.set(string: data, forKey: "Version")
    }

    // - Function: Retrieving key of DB from the SecureEnclave with Biometric Validation.
    func retrieveKeyBioMetric() -> String {
        let resultString: String
        switch KeyChainManager.BiometricValet.string(forKey: "Version", withPrompt: "Use BiometricID to retrieve password") {
        case let .success(password):
            resultString = password

        case .userCancelled:
            resultString = "user cancelled TouchID"

        case .itemNotFound:
            resultString = "object not found"
        }
        return resultString
    }
}
