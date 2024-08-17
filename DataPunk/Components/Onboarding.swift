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
            VStack(spacing: 30) {
                Button("我们帮你搞定") {
                    Task {
                        _ = createNewWallet()
                        privateKey = getPrivateKeyAddress()
                    }
                }
                .padding()
                .containerRelativeFrame(.horizontal, {width, _ in width * 0.8})
                .font(.title)
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 20, height: 20), style: .continuous))
                .shadow(radius: 5, y: 3)
                Button("点这里导入一个密钥") {
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
