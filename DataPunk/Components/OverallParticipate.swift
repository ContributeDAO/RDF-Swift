//
//  OverallParticipate.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import SwiftUI
import SwiftData

struct OverallParticipate: View {
    @Environment(\.modelContext) private var modelContext
    
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
        if joinedCampaigns.isEmpty {
            HStack(alignment: .center) {
                Spacer()
                Text("还没有参与活动哦")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .frame(height: 100)
        } else {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(joinedCampaigns) { campaign in
                        Rectangle()
                            .frame(width: 140, height: 200)
                            .overlay(RandomGradientBackground())
                            .overlay(
                                VStack {
                                    Text(campaign.title)
                                        .font(.title)
                                        .bold()
                                    Text(campaign.id.description)
                                        .font(.subheadline)
                                }
                                    .padding()
                            )
                            .rotation3DEffect(.degrees(2), axis: (x: 1, y: 0.7, z: 0.1))
                            .shadow(radius: 10, x: 0, y: 10)
                            .scaleEffect(0.8)
                            .contextMenu {
                                Button {
                                    try! campaign.reject(context: modelContext)
                                } label: {
                                    Label("退出", systemImage: "trash")
                                }
                            }
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    OverallParticipate()
}
