//
//  Date.swift
//  DataPunk
//
//  Created by 砚渤 on 8/18/24.
//

import Foundation

// Helper extension to format dates as ISO8601 strings
extension Date {
    func iso8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}
