//
//  SignContract.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import SwiftUI
import web3swift
import Web3Core

struct SignContract: View {
    let contractAddress: String
    let contract: ManagedContract?
    @State private var signError: String?
    
    init(contractAddress: String) {
        self.contractAddress = contractAddress
        do {
            self.contract = try ManagedContract(address: contractAddress)
            
        } catch {
            print(error)
            self.contract = nil
        }
    }
    
    var body: some View {
        if contract == nil {
            Text("Invalid contract address")
        } else {
            if signError != nil {
                Text(signError!)
            }
            Button {
                Task {
                    do {
                        try contract?.loadContract()
                        signError = try await String(contract?.readCredit() ?? .nan)
                    } catch {
                        DispatchQueue.main.async {
                            signError = "Failed to sign contract \(error)"
                        }
                    }
                }
            } label: {
                Text("Read Credit")
            }
        }
    }
}
