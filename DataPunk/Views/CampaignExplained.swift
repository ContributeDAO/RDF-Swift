//
//  CampaignExplained.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI

struct CampaignExplained: View {
    @State var campaign: Campaign

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Rectangle()
                    .overlay(RandomGradientBackground())
                    .frame(height: 200)
                    .padding(.horizontal)
                // Title
                Text(campaign.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)

                // Description
                Text(campaign.description)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                HStack {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("参与")
                        }
                        .padding(6)
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "clear")
                            Text("拒绝")
                        }
                        .padding(6)
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                .padding(.horizontal)
                
                Divider()

                // Organization
                Text("组织方")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Text(campaign.organization)
                    .font(.body)
                    .padding(.horizontal)
                
                Divider()
                
                // Address
                Text("合约地址")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Text(campaign.address)
                    .font(.body)
                    .padding(.horizontal)
                
                Divider()
                
                // Creation Date
                Text("发布日期")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Text(campaign.creationDate, style: .date)
                    .font(.body)
                    .padding(.horizontal)
                
                Divider()
                
                // Themes
                Text("领域主题")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                ForEach(campaign.themes, id: \.self) { theme in
                    Text(theme)
                        .font(.body)
                }
                .padding(.horizontal)

            }
            .padding(.vertical)
        }
        .navigationBarTitle("活动详情", displayMode: .inline)
    }
}

#Preview {
    CampaignExplained(campaign: Campaign.mockData.first!)
}