//
//  ImportKey.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/18.
//

import SwiftUI

struct ImportKey: View {
    @State private var newPrivateKey = ""
    @Binding var showPrivateKeyDialog: Bool
    
    var body: some View {
        VStack {
            TextField("Enter new private key", text: $newPrivateKey)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button("Save") {
                _ = createNewWallet(givenKey: newPrivateKey)
                newPrivateKey = ""
                showPrivateKeyDialog = false
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

