//
//  ChainProxy.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/18.
//

import Foundation
import Web3Core

struct ReadContractRequest: Encodable {
    var contractAddress: String
    var method: String
    var params: [String]
}

struct SlicedReceipt: Decodable {
    var status: String
    var gasUsed: String
    var effectiveGasPrice: String
    var from: String
    var blockHash: String
    var to: String
    var transactionHash: String
}

struct ReadTransactionResponse: Decodable {
    var status: String
    var receipt: SlicedReceipt
}

struct ReadContractResponse: Decodable {
    var status: String
    var receipt: String
}

let proxyBaseURL = "https://rdf-kv.vercel.app"

struct ChainProxy {
    let readURL = URL(string: "\(proxyBaseURL)/call")!
    let writeURL = URL(string: "\(proxyBaseURL)/send")!
    
    func readContract(_ properties: ReadContractRequest) async throws -> String {
        // Ensure keychain has a private key
        var privateKey: String = ""
        guard let index = listPrivateKeys().first else {
            throw Web3Error.walletError
        }
        privateKey = getPrivateKey(for: index) ?? ""
        
        assert(!privateKey.isEmpty)
        
        var request = URLRequest(url: readURL)
        request.httpMethod = "POST"
        request.httpBody = try JSONSerialization.data(withJSONObject: ["privateKey": privateKey, "contractAddress": properties.contractAddress, "method": properties.method, "params": properties.params])

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ReadContractResponse.self, from: data)
        
        return response.receipt
    }
    
    func writeContract(_ properties: ReadContractRequest) async throws -> String {
        // Ensure keychain has a private key
        var privateKey: String = ""
        guard let index = listPrivateKeys().first else {
            throw Web3Error.walletError
        }
        privateKey = getPrivateKey(for: index) ?? ""
        
        assert(!privateKey.isEmpty)
        
        var request = URLRequest(url: readURL)
        request.httpMethod = "POST"
        request.httpBody = try JSONSerialization.data(withJSONObject: ["privateKey": privateKey, "contractAddress": properties.contractAddress, "method": properties.method, "params": properties.params])

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ReadTransactionResponse.self, from: data)
        
        return response.receipt.transactionHash
    }
}
