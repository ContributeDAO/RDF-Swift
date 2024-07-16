//
//  Item.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import Foundation
import SwiftData

@Model
final class AppState {
    enum ContributeStyle: Codable {
        case intense, casual, conservative
    }
    enum ExperiencePhase: Codable {
        case onboarding, styleSelection, finished
    }
    
    var contributeStyle: ContributeStyle
    var experiencePhase: ExperiencePhase
    
    init() {
        self.contributeStyle = .casual
        self.experiencePhase = .onboarding
    }
}
