//
//  HealthIntegration.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import HealthKit

struct HealthIntegration {
    static var shared = HealthIntegration()
    
    var store: HKHealthStore?
    var storeAvailable: Bool {
        store != nil
    }
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
        }
    }
}
