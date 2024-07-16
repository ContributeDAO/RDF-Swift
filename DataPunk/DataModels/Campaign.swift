//
//  Campaign.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import Foundation

struct Campaign: Codable {
    let title: String
    let description: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
    }
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

extension Campaign {
    static let mockData = [
        Campaign(title: "Save the Rainforests", description: "Join us in preserving diverse ecosystems."),
        Campaign(title: "Ocean Cleanup", description: "Help remove plastics and other waste from our oceans."),
        Campaign(title: "Renewable Energy", description: "Support our initiative to increase renewable energy use."),
        Campaign(title: "Wildlife Protection", description: "Protect endangered species through conservation efforts."),
        Campaign(title: "Recycling Awareness", description: "Educate communities about the benefits of recycling.")
    ]
}
