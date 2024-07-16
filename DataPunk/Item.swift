//
//  Item.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
