//
//  CampaignCard.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI

struct CampaignCard: View {
    var campaign: Campaign

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(campaign.title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(campaign.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(5)
    }
}

#Preview {
    CampaignCard(campaign: Campaign(title: "Test Campaign", description: "This is a test campaign"))
}
