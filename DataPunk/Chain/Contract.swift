//
//  Contract.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import Foundation
import web3swift
import Web3Core

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
