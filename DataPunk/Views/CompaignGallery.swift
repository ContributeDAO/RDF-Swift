//
//  CompaignGallery.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI

struct CompaignGallery: View {
    @State private var campaigns: [Campaign] = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(campaigns, id: \.title) { campaign in
                            CampaignCard(campaign: campaign)
                        }
                    }
                    .padding()
                }
            }
            .refreshable {
                if let fetchedCampaigns = await fetchCampaigns() {
                    campaigns = fetchedCampaigns
                }
            }
            .navigationTitle("活动")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Filter button tapped")
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                }
            }
        }
        .onAppear {
            Task {
                if let fetchedCampaigns = await fetchCampaigns() {
                    campaigns = fetchedCampaigns
                }
            }
        }
    }
}

#Preview {
    CompaignGallery()
}
