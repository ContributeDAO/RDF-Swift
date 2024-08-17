//
//  DataPublished.swift
//  DataPunk
//
//  Created by 砚渤 on 8/18/24.
//

import Foundation
import SwiftData

@Model
final class DataPublished {
    var address: String
    var tasks: [String]
    var net: Double
    var date: Date
    
    init(address: String, tasks: [String], net: Double) {
        self.address = address
        self.tasks = tasks
        self.net = net
        self.date = Date.now
    }
}
