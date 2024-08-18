//
//  HealthIntegration.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import HealthKit
import CryptoKit

class HealthIntegration: ObservableObject {
    static var shared = HealthIntegration()
    
    var store: HKHealthStore?
    var storeAvailable: Bool {
        store != nil
    }
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
            retrieveSleepAnalysis()
            retrieveStepCountData()
            retrieveHeartRateData()
        }
        Task {
            await gainAuthorization()
        }
    }
    
    @Published var sleepData: [HKCategorySample] = []
    @Published var heartRateData: [HKQuantitySample] = []
    @Published var stepData: [HKQuantitySample] = []
    
    var stepCount: Int {
        stepData.reduce(0) { $0 + Int($1.quantity.doubleValue(for: .count())) }
    }
    
    var heartRateAverage: Int {
        let heartRateValues = heartRateData.map { $0.quantity.doubleValue(for: .count()) }
        return Int(heartRateValues.reduce(0, +) / Double(heartRateValues.count))
    }
    
    func gainAuthorization() async {
        guard let store = store else {
            return
        }
        let walkType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let heartBeatType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        
        do {
            try await store.requestAuthorization(toShare: [], read: [walkType, heartBeatType, sleepType])
            retrieveSleepAnalysis()
            retrieveStepCountData()
            retrieveHeartRateData()
        } catch {
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
    
    // Retrieve Sleep Data
    func retrieveSleepAnalysis() {
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) { (query, result, error) in
                if let error = error {
                    print("Error retrieving sleep data: \(error.localizedDescription)")
                    return
                }
                if let result = result as? [HKCategorySample] {
                    DispatchQueue.main.async {
                        self.sleepData = result
                    }
                }
            }
            store?.execute(query)
        }
    }
    
    // Retrieve Step Count Data
    func retrieveStepCountData() {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now.advanced(by: -86400))
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now)
        
        let query = HKSampleQuery(sampleType: stepsQuantityType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, result, error) in
            if let error = error {
                print("Error retrieving step count data: \(error.localizedDescription)")
                return
            }
            if let result = result as? [HKQuantitySample] {
                print(result)
                DispatchQueue.main.async {
                    self.stepData = result
                }
            }
        }
        store?.execute(query)
    }
    
    // Retrieve Heart Rate Data
    func retrieveHeartRateData() {
        let heartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now)
        
        let query = HKSampleQuery(sampleType: heartRateQuantityType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, result, error) in
            if let error = error {
                print("Error retrieving heart rate data: \(error.localizedDescription)")
                return
            }
            if let result = result as? [HKQuantitySample] {
                DispatchQueue.main.async {
                    self.heartRateData = result
                }
            }
        }
        store?.execute(query)
    }
    
    func exportDataAsJSON() -> Data? {
            var exportData: [String: Any] = [:]
            
            // Convert sleep data
            let sleepArray = sleepData.map { sample -> [String: Any] in
                return [
                    "startDate": sample.startDate.iso8601String(),
                    "endDate": sample.endDate.iso8601String(),
                    "value": sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue ? "InBed" : "Asleep"
                ]
            }
            
            // Convert step data
            let stepArray = stepData.map { sample -> [String: Any] in
                return [
                    "startDate": sample.startDate.iso8601String(),
                    "endDate": sample.endDate.iso8601String(),
                    "count": sample.quantity.doubleValue(for: HKUnit.count())
                ]
            }
            
            // Convert heart rate data
            let heartRateArray = heartRateData.map { sample -> [String: Any] in
                return [
                    "startDate": sample.startDate.iso8601String(),
                    "endDate": sample.endDate.iso8601String(),
                    "bpm": sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                ]
            }
            
            // Add arrays to export dictionary
            exportData["sleepData"] = sleepArray
            exportData["stepData"] = stepArray
            exportData["heartRateData"] = heartRateArray
            
            // Convert dictionary to JSON
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
                return jsonData
            } catch {
                print("Error converting data to JSON: \(error.localizedDescription)")
                return nil
            }
        }
    
    // Share data securely with encryption
    func shareData(encryptionKey: SymmetricKey) -> Data? {
        guard let data = exportDataAsJSON() else {
            return nil
        }
        var doc = EncryptableDocument(data: data)
        doc.encryptData(with: encryptionKey)
        return doc.encryptedData
    }
}
