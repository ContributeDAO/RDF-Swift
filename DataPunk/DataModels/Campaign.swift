//
//  Campaign.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import Foundation

struct Campaign: Codable, Hashable {
    let title: String
    let themes: [String]
    let description: String
    let address: String
    let creationDate: Date
    let organization: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.address = try container.decode(String.self, forKey: .address)
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        self.organization = try container.decode(String.self, forKey: .organization)
        self.themes = try container.decode([String].self, forKey: .themes)
    }
    
    init(
        title: String,
        themes: [String],
        description: String,
        address: String,
        creationDate: Date,
        organization: String
    ) {
        self.title = title
        self.themes = themes
        self.description = description
        self.address = address
        self.creationDate = creationDate
        self.organization = organization
    }
}

struct KVAPI {
    static let baseURLString = ProcessInfo.processInfo.environment["KV_BASE_URL"]!
    enum Endpoint: String {
        case campaigns = "/get/campaigns"
        case availableThemes = "/get/availableThemes"
    }
    
    static func makeRequest(for endpoint: Endpoint) -> URLRequest {
        let url = URL(string: baseURLString + endpoint.rawValue)!
        let token = ProcessInfo.processInfo.environment["KV_REST_RO_TOKEN"]!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }
    
    struct WrappedCampaign: Codable {
        let result: String
    }
}

func fetchCampaigns(filterBy themes: [String]? = nil) async -> [Campaign]? {
    let request = KVAPI.makeRequest(for: .campaigns)
    var allCampaigns: [Campaign]? = nil
    
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let rawResult = try KVAPI.decoder.decode(KVAPI.WrappedCampaign.self, from: data).result.data(using: .utf8)
        if let rawResult = rawResult {
            allCampaigns = try KVAPI.decoder.decode([Campaign].self, from: rawResult)
        } else {
            print("Failed to decode campaigns")
        }
    } catch {
        print("Failed to fetch campaigns: \(error)")
    }
    
    if let allCampaigns = allCampaigns {
        if themes == nil {
            return allCampaigns
        }
        return allCampaigns.filter { $0.themes.contains(themes!) }
    }
    
    return nil
}

func fetchAvailableThemes() async -> [String]? {
    let request = KVAPI.makeRequest(for: .availableThemes)
    var availableThemes: [String]? = nil
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        availableThemes = try KVAPI.decoder.decode([String].self, from: data)
    } catch {
        print("Failed to fetch available themes: \(error)")
    }
    
    return availableThemes
}

extension Campaign {
    static let mockData = [
        Campaign(title: "Save the Rainforests", themes: ["Environmental"], description: "Join us in preserving diverse ecosystems and protecting the habitats of countless species living in the rainforests.", address: "123 Forest Rd, Amazon Basin", creationDate: Date(), organization: "Green Earth"),
        Campaign(title: "Clean Water Initiative", themes: ["Environmental", "SocialJustice"], description: "Provide clean and safe drinking water to underserved communities around the globe.", address: "47 Water Stream Rd, Malawi", creationDate: Date(), organization: "H2Ope"),
        Campaign(title: "Medical Aid for Remote Areas", themes: ["Medical"], description: "Deliver essential medical supplies and services to remote areas lacking adequate healthcare facilities.", address: "303 Remote Path, Nepal", creationDate: Date(), organization: "Health for All"),
        Campaign(title: "Tech Education for Youth", themes: ["SocialJustice"], description: "Bridge the digital divide by providing underprivileged youth with access to technology education.", address: "202 Innovation Blvd, Silicon Valley", creationDate: Date(), organization: "Future Coders"),
        Campaign(title: "Ocean Cleanup", themes: ["Environmental"], description: "Help remove plastics and other waste from our oceans to protect marine life and improve water quality.", address: "500 Coastal Area, Pacific Ocean", creationDate: Date(), organization: "Blue Waters"),
        Campaign(title: "Renewable Energy Now", themes: ["Environmental"], description: "Accelerate the adoption of renewable energy by supporting solar and wind energy projects.", address: "750 Solar Park Ave, Morocco", creationDate: Date(), organization: "Energy Future"),
        Campaign(title: "Equality and Justice", themes: ["SocialJustice"], description: "Promote equality and justice through legal aid, policy change, and public awareness campaigns.", address: "350 Justice Way, New York City", creationDate: Date(), organization: "Equal Rights"),
        Campaign(title: "Disaster Relief Effort", themes: ["Medical", "SocialJustice"], description: "Provide immediate and ongoing support for areas affected by natural disasters.", address: "100 Emergency Ln, Indonesia", creationDate: Date(), organization: "Rapid Response"),
        Campaign(title: "Wildlife Protection", themes: ["Environmental", "SocialJustice"], description: "Protect endangered species through conservation efforts and fight against illegal wildlife trafficking.", address: "800 Safari Zone, Kenya", creationDate: Date(), organization: "Wildlife Guardians"),
        Campaign(title: "Community Recycling Projects", themes: ["Environmental", "SocialJustice"], description: "Educate communities about the benefits of recycling and set up local recycling projects.", address: "450 Recycle Rd, San Francisco", creationDate: Date(), organization: "Eco Warriors")
    ]
}
