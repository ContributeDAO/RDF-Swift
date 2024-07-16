//
//  Onboarding.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI

struct Onboarding: View {
    var body: some View {
        Text("建立你的身份凭证")
            .font(.largeTitle)
            .bold()
        Spacer()
        if listAllKeys().isEmpty {
            Button("添加一个密钥") {
                _ = createNewWallet()
            }
            .font(.title)
            .buttonStyle(BorderedButtonStyle())
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
