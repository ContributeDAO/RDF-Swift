//
//  CompaignGallery.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI

struct CompaignGallery: View {
    var campaigns: [Campaign] = Campaign.mockData
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(campaigns, id: \.title) { campaign in
                            CampaignCard(campaign: campaign)
                        }
                    }
                    .padding()
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
    }
}

#Preview {
    CompaignGallery()
}
