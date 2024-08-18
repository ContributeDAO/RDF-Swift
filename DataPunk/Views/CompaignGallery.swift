//
//  CompaignGallery.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI

struct CompaignGallery: View {
    @State private var campaigns: [Campaign] = []
    
    @Namespace() var namespace
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(campaigns, id: \.title) { campaign in
                        NavigationLink {
                            CampaignExplained(campaign: campaign)
                                .navigationTransition(.zoom(sourceID: campaign, in: namespace))
                        } label: {
                            CampaignCard(campaign: campaign)
                                .matchedTransitionSource(id: campaign, in: namespace)
                        }
                        .shadow(radius: 3, y: 1)
                        
                    }
                }
                .padding()
            }
            .refreshable {
                if let fetchedCampaigns = await fetchCampaigns() {
                    campaigns = fetchedCampaigns
                }
            }
            .navigationTitle("活动")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("Filter button tapped")
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .font(.title3)
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
