//
//  Campaign.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import Foundation
import SwiftData
import CryptoKit

@Model
final class Campaign: Decodable, Hashable {
    var title: String
    var themes: [String]
    var subtitle: String
    var address: String
    var creationDate: String
    var organization: String
    var encryptionKey: String? = nil
    
    
    init(
        title: String,
        themes: [String],
        description: String,
        address: String,
        creationDate: String,
        organization: String
    ) {
        self.title = title
        self.themes = themes
        self.subtitle = description
        self.address = address
        self.creationDate = creationDate
        self.organization = organization
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case themes = "themes"
        case description = "description"
        case address = "address"
        case creationDate = "creationDate"
        case organization = "organization"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        themes = try container.decode([String].self, forKey: .themes)
        subtitle = try container.decode(String.self, forKey: .description)
        address = try container.decode(String.self, forKey: .address)
        creationDate = try container.decode(String.self, forKey: .creationDate)
        organization = try container.decode(String.self, forKey: .organization)
    }
    
    func participate() async throws {
        // TODO: Write transcation code
        encryptionKey = keyb64(SymmetricKey(size: .bits256))
        //
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
        let rawResult = try KVAPI.decoder.decode(KVAPI.WrappedCampaign.self, from: data).result
        print(rawResult)
//        if let rawResult = rawResult {
            allCampaigns = try KVAPI.decoder.decode([Campaign].self, from: rawResult.data(using: .utf8)!)
//        } else {
//            print("Failed to decode campaigns")
//        }
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
        Campaign(title: "Save the Rainforests", themes: ["Environmental"], description: "Join us in preserving diverse ecosystems and protecting the habitats of countless species living in the rainforests.", address: "123 Forest Rd, Amazon Basin", creationDate: "Date()", organization: "Green Earth")
    ]
}
