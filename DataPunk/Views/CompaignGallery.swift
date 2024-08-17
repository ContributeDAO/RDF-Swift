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
    
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 500)),
        GridItem(.adaptive(minimum: 150, maximum: 500)),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns) {
                        ForEach(campaigns, id: \.title) { campaign in
                            NavigationLink {
                                CampaignExplained(campaign: campaign)
                                    .navigationTransition(.zoom(sourceID: campaign, in: namespace))
                            } label: {
                                CampaignCard(campaign: campaign)
                                    .shadow(radius: 3, y: 1)
                                    .padding()
                            }
                            .matchedTransitionSource(id: campaign, in: namespace)
                        }
                    }
                }
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
