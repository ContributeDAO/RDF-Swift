import SwiftUI
import SwiftData

func removeFractionalSeconds(from dateString: String) -> String {
    let pattern = "\\.\\d{3}Z"
    let regex = try! NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: dateString.utf16.count)
    return regex.stringByReplacingMatches(in: dateString, options: [], range: range, withTemplate: "Z")
}

struct CampaignExplained: View {
    @Environment(\.modelContext) private var modelContext
    @State var campaign: Campaign
    
    var dateString: String {
        do {
            let date = try Date(removeFractionalSeconds(from: campaign.creationDate), strategy: .iso8601)
            return date.formatted()
        } catch {
            return "未知"
        }
    }
    
    var status: Campaign.JoinStatus {
        if let it = try? campaign.getItselfInDatabase(context: modelContext) {
            return Campaign.JoinStatus(rawValue: it.joinStatus) ?? .new
        } else {
            return .new
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Rectangle()
                    .overlay(RandomGradientBackground())
                    .frame(height: 200)
                    .padding(.horizontal)
                    .rotation3DEffect(
                        .degrees(status == .joined ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.3 // Adjust perspective for subtle effect
                    )
                    .saturation(status == .joined ? 1.0 : 0.1) // Increase saturation when joined
                    .shadow(color: .black.opacity(status == .joined ? 0.4 : 0), radius: status == .joined ? 4 : 0, x: 0, y: 2)
                    .animation(.spring(duration: 0.6), value: status == .joined)
                
                // Title
                Text(campaign.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)
                    .strikethrough(try! campaign.getItselfInDatabase(context: modelContext).joinStatus == Campaign.JoinStatus.rejected.rawValue, color: .red)
                // Description
                Text(campaign.subtitle)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                HStack {
                    if status != .joined {
                        Button {
                            try! campaign.participate(context: modelContext)
                        } label: {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("参与")
                            }
                            .padding(6)
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                    } else {
                        Button(role: .destructive) {
                            try! campaign.reject(context: modelContext)
                        } label: {
                            HStack {
                                Image(systemName: "xmark")
                                Text("退出")
                            }
                            .padding(6)
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                    }
                    
                    if status == .new {
                        Button {
                            try! campaign.reject(context: modelContext)
                        } label: {
                            HStack {
                                Image(systemName: "clear")
                                Text("拒绝")
                            }
                            .padding(6)
                        }
                        .buttonStyle(BorderedButtonStyle())
                    }
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
                Text("合约 ID")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Text(campaign.id.description)
                    .font(.body)
                    .padding(.horizontal)
                
                Divider()
                
                // Creation Date
                Text("发布日期")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Text(dateString)
                    .font(.body)
                    .padding(.horizontal)
                
                
                // Themes
                if !campaign.themes.isEmpty {
                    Divider()
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
                
            }
            .padding(.vertical)
        }
        .navigationBarTitle("活动详情", displayMode: .inline)
    }
}

#Preview {
    CampaignExplained(campaign: Campaign.mockData.first!)
}
