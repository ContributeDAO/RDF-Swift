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
        .background(Color(white: 0.95))
        .cornerRadius(10)
    }
}

#Preview {
    CampaignCard(campaign: Campaign.mockData.first!)
}
