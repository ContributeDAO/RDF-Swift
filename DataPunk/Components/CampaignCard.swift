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
            Text(campaign.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(
            ZStack {
                RandomGradientBackground()
                RadialGradient(gradient: Gradient(colors: [Color.white, Color.white.opacity(0)]), center: .init(x: 0.5, y: -0.05), startRadius: 20, endRadius: 200)
            }
        )
        .cornerRadius(10)
    }
}

struct RandomGradientBackground: View {
    var body: some View {
        let colors = [Color.red, Color.blue, Color.green, Color.yellow, Color.purple, Color.orange].shuffled()
        let gradient1 = LinearGradient(gradient: Gradient(colors: [colors[0], colors[1]]), startPoint: .topLeading, endPoint: .bottomTrailing)
        let gradient2 = LinearGradient(gradient: Gradient(colors: [colors[2], colors[3]]), startPoint: .topTrailing, endPoint: .bottomLeading)

        return ZStack {
            gradient1
            gradient2.opacity(0.5)
            Color.white.opacity(0.9)
        }
    }
}

#Preview {
    CampaignCard(campaign: Campaign.mockData.first!)
}
