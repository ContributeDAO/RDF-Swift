//
//  MyStats.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import SwiftUI
import SwiftData
import HealthKit
import CryptoKit

struct MyStats: View {
    @State var uploading = false
    @State var encryptionKey = SymmetricKey(size: .bits256)
    @State var uploadDocument: Data? = nil
    @StateObject var health = HealthIntegration.shared
    
    @Query private var campaigns: [Campaign]
    @Query private var joinedCampaigns: [Campaign]
    
    init() {
        let joinedStatus = Campaign.JoinStatus.joined.rawValue
        let filter = #Predicate<Campaign> { campaign in
            campaign.joinStatus == joinedStatus
        }
        _joinedCampaigns = Query(filter: filter)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVStack(spacing: -10) {
                        StatCard(
                            iconName: "figure.walk",
                            title: "步行",
                            value: health.stepData.isEmpty ? nil : "\(health.stepCount)",
                            showProgress: health.stepData.isEmpty,
                            animationDelay: 0.6 // 设置延迟使其更晚出现
                        )
                        
                        StatCard(
                            iconName: "heart.fill",
                            title: "心跳",
                            value: health.heartRateData.isEmpty ? nil : "\(health.heartRateAverage)",
                            showProgress: health.heartRateData.isEmpty,
                            animationDelay: 0.5 // 中间的卡片
                        )
                        
                        StatCard(
                            iconName: "bed.double.fill",
                            title: "睡眠",
                            value: health.sleepData.isEmpty ? nil : "\(health.sleepData.count)/30",
                            showProgress: health.sleepData.isEmpty,
                            animationDelay: 0.4 // 最早出现的卡片
                        )
                        
                        // Placeholder Stats
                        ForEach(0..<3, id: \.self) { index in
                            StatCard(
                                iconName: "circle",
                                title: "数据",
                                value: "...",
                                animationDelay: 0.3 - Double(index) * 0.1 // 延迟依次增加
                            )
                        }
                    }
                    .padding(.top, 20)
                }
                .navigationTitle("感知")
                .toolbarTitleDisplayMode(.inlineLarge)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if let uploadDocument = uploadDocument {
                            ShareLink(
                                item: uploadDocument,
                                subject: Text("加密数据"),
                                preview: SharePreview("加密数据", image: Image(systemName: "lock.doc"))
                            )
                            .font(.title3)
                        } else {
                            Button {
                                uploading = true
                                uploadDocument = HealthIntegration.shared.shareData(encryptionKey: encryptionKey)
                                Task {
                                    let _ = keyb64(encryptionKey)
                                    print("uploading campaign count:", joinedCampaigns.count)
                                    for joinedCampaign in joinedCampaigns {
                                        print("uploading to \(joinedCampaign.id)")
                                        try await _ = ChainProxy().writeContract(.init(method: "uploadDataset", params: [joinedCampaign.id]))
                                    }
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
