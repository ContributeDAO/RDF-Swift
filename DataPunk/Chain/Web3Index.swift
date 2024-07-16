//
//  Web3.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import Foundation
import web3swift
import Web3Core
import Security
import KeychainSwift

fileprivate func generateSecureRandomBytes() -> Data? {
    var keyData = Data(count: 32)
    let result = keyData.withUnsafeMutableBytes {
        SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
    }
    if result == errSecSuccess {
        return keyData
    } else {
        print("Error generating random bytes: \(result)")
        return nil
    }
}

func createNewWallet() -> (address: String, privateKey: String)? {
    let keychain = KeychainSwift()  // Initialize KeychainSwift
    do {
        // Generate a new private key
        guard let privateKey = generateSecureRandomBytes() else {
            print("Failed to generate secure random bytes for private key")
            return nil
        }
        _ = privateKey.toHexString()
        
        // Initialize an Ethereum keystore with the new private key
        guard let keystore = try EthereumKeystoreV3(privateKey: privateKey, password: "") else {
            print("Failed to create a new keystore")
            return nil
        }
        
        // Get the first Ethereum address from the keystore
        guard let address = keystore.addresses?.first else {
            print("Failed to retrieve address from keystore")
            return nil
        }
        
        // Get the private key data back from the keystore (optional, be cautious)
        let retrievedPrivateKeyData = try keystore.UNSAFE_getPrivateKeyData(password: "", account: address)
        let privateKeyHex = retrievedPrivateKeyData.toHexString()
        
        // Store the private key in the Keychain
        keychain.set(privateKeyHex, forKey: "privateKey_\(address.address)")
        
        print("New wallet created. Address: \(address.address), Private Key: \(privateKeyHex)")
        return (address: address.address, privateKey: privateKeyHex)
    } catch {
        print("An error occurred: \(error)")
        return nil
    }
}

func listAllKeys() -> [String] {
    let keychain = KeychainSwift()
    let allKeys = keychain.allKeys
    
    for key in allKeys where key.starts(with: "privateKey_") {
        print("Keychain has key: \(key)")
    }
    
    let relevantKeys = allKeys.filter { $0.starts(with: "privateKey_") }
    
    return relevantKeys
}

func getPrivateKey(for key: String) -> String? {
    let keychain = KeychainSwift()
    return keychain.get(key)
}

func removePrivateKey(for address: String) {
    let keychain = KeychainSwift()
    keychain.delete("privateKey_\(address)")
    print("Removed private key for address: \(address)")
}
