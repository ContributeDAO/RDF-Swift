//
//  DeviceCheck.swift
//  DataPunk
//
//  Created by 砚渤 on 8/17/24.
//

import SwiftUI
import DeviceCheck

class DeviceCheckModel: ObservableObject {
    enum TokenStatus {
        case notGenerated
        case generated(String)
        case error(String)
    }
    
    @Published var tokenStatus: TokenStatus = .notGenerated
    
    init() {
        generateToken()
    }
    
    func generateToken() {
        if #available(iOS 11.0, *) {
            DCDevice.current.generateToken { (data, error) in
                DispatchQueue.main.async {
                    if let data = data {
                        self.tokenStatus = .generated(data.base64EncodedString())
                    } else if let error = error {
                        self.tokenStatus = .error(error.localizedDescription)
                    } else {
                        self.tokenStatus = .error("Unknown error occurred")
                    }
                }
            }
        } else {
            self.tokenStatus = .error("DeviceCheck not available on this device")
        }
    }
    
    var statusText: String {
        switch tokenStatus {
        case .notGenerated:
            return "尚未验证你的设备"
        case .generated:
            return "你的设备有效！"
        case .error(let string):
            return "Error: \(string)"
        }
    }
    
    var statusColor: Color {
        switch tokenStatus {
        case .notGenerated:
            return .gray
        case .generated:
            return .green
        case .error:
            return .red
        }
    }
}
