//
//  MyStats.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import SwiftUI
import HealthKit
import CryptoKit

struct MyStats: View {
    @State var uploading = false
    @State var encryptionKey = SymmetricKey(size: .bits256)
    @State var stepSet: [Date: Int] = [:]
    @State var heartRateSet: [Date: Int] = [:]
    @State var uploadDocument: Data? = nil
    
    var stepSum: Int {
        stepSet.values.reduce(0, +)
    }
    
    var hearRateAverage: Int {
        heartRateSet.values.reduce(0, +) / heartRateSet.count
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVStack(spacing: -10) {
                        // steps walked
                        HStack {
                            Image(systemName: "figure.walk")
                                .font(.largeTitle)
                            Text("步行")
                                .font(.largeTitle)
                            Spacer()
                            if !stepSet.isEmpty {
                                Text("\(stepSum)")
                                    .font(.title)
                            } else {
                                ProgressView()
                                    .font(.title)
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 16, bottom: 40, trailing: 16))
                        .background(RandomGradientBackground())
                        .shadow(color: .black.opacity(0.1), radius: 20)
                        HStack {
                            Image(systemName: "heart.fill")
                                .font(.largeTitle)
                            Text("心跳")
                                .font(.largeTitle)
                            Spacer()
                            if !heartRateSet.isEmpty {
                                Text("\(hearRateAverage)")
                                    .font(.title)
                            } else {
                                ProgressView()
                                    .font(.title)
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 16, bottom: 40, trailing: 16))
                        .background(RandomGradientBackground())
                        .shadow(color: .black.opacity(0.1), radius: 20)
                        
                        // placeholder
                        ForEach(0..<5, id: \.self) { _ in
                            HStack {
                                Image(systemName: "circle")
                                    .font(.largeTitle)
                                Text("数据")
                                    .font(.largeTitle)
                                Spacer()
                                Text("...")
                                    .font(.title)
                            }
                            .padding(EdgeInsets(top: 20, leading: 16, bottom: 40, trailing: 16))
                            .background(RandomGradientBackground())
                            .shadow(color: .black.opacity(0.1), radius: 20)
                        }
                    }
                    .padding(.top, 20)
                    .onAppear {
                        // connect healthkit
                        // fetch steps walked
                        
                        if let walkType = HKQuantityType.quantityType(forIdentifier: .stepCount), let heartBeatType = HKQuantityType.quantityType(forIdentifier: .heartRate), let store = HealthIntegration.shared.store {
                            Task {
                                try await store.requestAuthorization(toShare: [], read: [walkType, heartBeatType])
                                HealthIntegration.shared.sampleStepData { pair in
                                    DispatchQueue.main.async {
                                        stepSet.merge(pair) { _, new in new
                                        }
                                    }
                                    HealthIntegration.shared.sampleHeartRateData { pair in
                                        DispatchQueue.main.async {
                                            heartRateSet.merge(pair) { _, new in new }
                                        }
                                    }
                                }
                            }
                        }
                        VStack {
                            DocumentPicker(key: $encryptionKey)
                            SignContract(contractAddress: "0x28b254d742a84F72Cf0e41E436ae0b65353b78b9")
                        }
                        .padding()
                    }
                }
                .navigationTitle("感知")
                .toolbarTitleDisplayMode(.inlineLarge)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if uploadDocument != nil {
                            ShareLink(item: uploadDocument!, subject: Text("加密数据"), preview: SharePreview("加密数据", image: Image(systemName: "lock.doc")))
                                .font(.title3)
                        } else {
                            Button {
                                uploading = true
                                let dataSet = [
                                    "steps": stepSet,
                                    "heartRate": heartRateSet
                                ]
                                let data = try! JSONEncoder().encode(dataSet)
                                print(data)
                                uploadDocument = HealthIntegration.shared.shareData(data, encryptionKey: encryptionKey)
                                Task {
                                    let key = keyb64(encryptionKey)
                                    // MARK: The contract arbitary
                                    try await _ = ChainProxy().writeContract(.init(contractAddress: "0xE40A54Ab449fd2F3d702f6430f76d966Fb97B66E", method: "contributeData", params: [Date.now.ISO8601Format(), key]))
                                }
                            } label: {
                                if !uploading {
                                    Image(systemName: "arrow.up.circle.fill")
                                } else {
                                    ProgressView()
                                }
                            }
                            .font(.title3)
                        }
                    }
                }
                
            }
        }
    }
}

#Preview {
    MyStats()
}
