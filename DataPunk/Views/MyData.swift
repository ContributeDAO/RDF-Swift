//
//  MyData.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import SwiftUI
import SwiftData
import Web3Core
import web3swift

struct MyData: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var deviceCheckModel: DeviceCheckModel
    @Query private var appStates: [AppState]
    @State private var showPrivateKeyDialog = false
    @State private var newPrivateKey: String = ""
    @State private var balance: String = ""
    
    private var appState: AppState {
        if appStates.isEmpty {
            modelContext.insert(AppState())
            try! modelContext.save()
        }
        return appStates.first!
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(alignment: .center) {
                        Text("数据使用")
                            .font(.title.weight(.semibold))
                        Spacer()
                        Button("明细") {
                            
                        }
                        .buttonStyle(ChevronButtonStyle())
                    }
                    .listRowSeparator(.hidden)
                    OverallChart()
                        .frame(height: 200)
                }
                .padding(5)
                Section {
                    HStack(alignment: .center) {
                        Text("加入活动记录")
                            .font(.title.weight(.semibold))
                        Spacer()
                        Button("明细") {
                            
                        }
                        .buttonStyle(ChevronButtonStyle())
                    }
                    .listRowSeparator(.hidden)
                    OverallParticipate()
                        .padding(-25)
                }
                .padding(5)
                Section {
                    DeviceCheckView()
                        .listRowBackground(deviceCheckModel.statusColor.opacity(0.1))
                        .listRowSeparator(.hidden)
                    Button("钱包余额 \(balance)") {
                        if let address = getPrivateKeyAddress() {
                            let addr = EthereumAddress(from: address)
                            Task {
                                let balanceUint = try await web3?.eth.getBalance(for: addr!)
                                if let balance = balanceUint {
                                    self.balance = balance.description
                                }
                            }
                        }
                    }
                    Button("重新开始") {
                        appState.experiencePhase = .onboarding
                        try! modelContext.save()
                    }
                    Button("退出所有活动") {
                        let predicate = #Predicate<Campaign> { _ in
                            true
                        }
                        (( try? modelContext.fetch(.init(predicate:predicate))) ?? []).forEach {
                            modelContext.delete($0)
                        }
                        try! modelContext.save()
                    }
                    Button(role: .destructive) {
                        removeAllPrivateKeys()
                    } label: {
                        Text("清除所有钱包")
                    }
                    // replace keys
                    Button(role: .destructive) {
                        showPrivateKeyDialog = true
                    } label: {
                        Text("更改钱包")
                    }
                    .sheet(isPresented: $showPrivateKeyDialog) {
                        ImportKey(showPrivateKeyDialog: $showPrivateKeyDialog)
                    }
                }
            }
            .listSectionSpacing(10)
            .navigationTitle("我的数据")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

#Preview {
    MyData()
}
