//
//  HealthIntegration.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import HealthKit
import CryptoKit

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
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        print(startOfDay)
        print(now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now
        )
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate) { query, statistics, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    print(error.localizedDescription)
                }
                if let sum = statistics?.sumQuantity(){
                    completion(sum.doubleValue(for: HKUnit.count()))
                }
                
            }
        }
        store?.execute(query)
    }
    
    // sample walking data by hour in the past day
    func sampleStepData(completion: @escaping ([Date: Int]) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        var start = Calendar.current.startOfDay(for: now)
        
        while start < now {
            let predicate = HKQuery.predicateForSamples(
                withStart: start,
                end: Calendar.current.date(byAdding: .hour, value: 1, to: start)
            )
            let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate) { query, statistics, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error)
                        print(error.localizedDescription)
                    }
                    if let sum = statistics?.sumQuantity(){
                        completion([start: Int(sum.doubleValue(for: HKUnit.count()))])
                    }
                    
                }
            }
            store?.execute(query)
            start = Calendar.current.date(byAdding: .hour, value: 1, to: start)!
        }
    }
    
    func getTodayHeartrate(completion: @escaping (Double) -> Void) {
        let heartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        print(startOfDay)
        print(now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now
        )
        let query = HKStatisticsQuery(quantityType: heartRateQuantityType, quantitySamplePredicate: predicate) { query, statistics, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    print(error.localizedDescription)
                }
                if let sum = statistics?.sumQuantity(){
                    completion(sum.doubleValue(for: HKUnit.count()))
                }
                
            }
        }
        store?.execute(query)
    }
    
    func sampleHeartRateData(completion: @escaping ([Date: Int]) -> Void) {
        let heartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        let now = Date()
        var start = Calendar.current.startOfDay(for: now)
        
        while start < now {
            let predicate = HKQuery.predicateForSamples(
                withStart: start,
                end: Calendar.current.date(byAdding: .hour, value: 1, to: start)
            )
            let query = HKStatisticsQuery(quantityType: heartRateQuantityType, quantitySamplePredicate: predicate) { query, statistics, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error)
                        print(error.localizedDescription)
                    }
                    if let sum = statistics?.sumQuantity(){
                        completion([start: Int(sum.doubleValue(for: HKUnit.count()))])
                    }
                    
                }
            }
            store?.execute(query)
            start = Calendar.current.date(byAdding: .hour, value: 1, to: start)!
        }
    }
    
    func shareData(_ data: Data, encryptionKey: SymmetricKey) -> Data? {
        var doc = EncryptableDocument(data: data)
        doc.encryptData(with: encryptionKey)
        return doc.encryptedData
    }
}
