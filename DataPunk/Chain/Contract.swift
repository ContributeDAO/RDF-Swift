//
//  Contract.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import Foundation
import web3swift
import Web3Core

import CryptoKit

struct ManagedContract {
    let address: EthereumAddress
    var contract: Web3.Contract?
    
    enum ContractError: Error {
        case invalidAddress
    }
    
    init(address: String) throws {
        guard let ethAddress = EthereumAddress(address) else {
            throw ContractError.invalidAddress
        }
        
        self.address = ethAddress
    }
    
    func loadContract() -> Web3.Contract? {
        guard let web3 = web3 else {
            return nil
        }
        return web3.contract(Web3.Utils.erc20ABI, at: address)!
    }
}

/*encryptFile*/
func encryptFile(atPath path: String, using key: SymmetricKey, outputPath: String) throws {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    let sealedBox = try AES.GCM.seal(data, using: key)
    let encryptedData = sealedBox.combined

    try encryptedData.write(to: URL(fileURLWithPath: outputPath))
}

/*decryptFile*/
func decryptFile(atPath path: String, using key: SymmetricKey, outputDecryptedPath: String) throws {
    let encryptedData = try Data(contentsOf: URL(fileURLWithPath: path))
    let nonce = try AES.GCM.Nonce(data: encryptedData.prefix(12))
    let ciphertext = encryptedData.suffix(from: encryptedData.index(encryptedData.startIndex, offsetBy: 12))
    let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
    let decryptedData = try AES.GCM.open(sealedBox, using: key)

    try decryptedData.write(to: URL(fileURLWithPath: outputDecryptedPath))
    print("Decrypted file saved to \(outputDecryptedPath)")
}