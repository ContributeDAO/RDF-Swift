//
//  Onboarding.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI

struct Onboarding: View {
    @State var privateKey: String? = nil
    @State var importingPrivateKey = false
    
    var body: some View {
        Text("建立你的身份凭证")
            .font(.largeTitle)
            .bold()
        Spacer()
        if privateKey == nil {
            VStack {
                Button("添加一个密钥") {
                    Task {
                        _ = createNewWallet()
                        privateKey = getPrivateKeyAddress()
                    }
                }
                .font(.title)
                .buttonStyle(BorderedButtonStyle())
                Button("导入一个密钥") {
                    importingPrivateKey = true
                }
                .sheet(isPresented: $importingPrivateKey) {
                    ImportKey(showPrivateKeyDialog: $importingPrivateKey)
                }
            }
        } else {
            Image(systemName: "checkmark.seal")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    Onboarding()
}
