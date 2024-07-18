//
//  Contract.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import Foundation
import web3swift
import Web3Core
import UniformTypeIdentifiers
import CryptoKit

class ManagedContract {
    let address: EthereumAddress
    let walletAddress: EthereumAddress
    var contract: Web3.Contract?
    
    enum ContractError: Error {
        case invalidAddress, abiNotFound, deploymentFailed, invalidOperation, invalidResult
    }
    
    init(address contractAddress: String, walletAddress: String? = nil) throws {
        guard let result = EthereumAddress(contractAddress) else {
            throw ContractError.invalidAddress
        }
        
        self.address = result
        if listPrivateKeys().isEmpty {
            throw Web3Error.walletError
        }
        let walletString = walletAddress ?? getPrivateKeyAddress()
        let walletAddressE = EthereumAddress(walletString!)
        if walletAddressE == nil {
            throw ContractError.invalidAddress
        }
        self.walletAddress = walletAddressE!
    }
    
    func loadContract() throws {
        guard let web3 = web3 else {
            throw Web3Error.walletError
        }
        contract = web3.contract(readABIString(named: "DataNFTContract")!, at: address)
    }
    
    func readCredit() async throws -> Float {
        // Ensure web3 instance is available
        guard let web3 = web3 else {
            throw Web3Error.walletError
        }
        
        // Attempt to load the contract if not already loaded
        if contract == nil {
            try loadContract()  // Ensure this function either throws correctly, or is awaited if async
        }
        
        print("Reading credit")
        
        return try await Float(ChainProxy().readContract(.init(contractAddress: address.address, method: "totalSupply", params: []))) ?? .nan
        
//        if let operation = contract?.createReadOperation("totalSupply", parameters: [], extraData: Data()) {
//        }
        
    }
}
