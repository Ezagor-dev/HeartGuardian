//
//  HeartRateManager.swift
//  HeartGuardianWatchApp Watch App
//
//  Created by Ezagor on 26.11.2023.
//

import HealthKit
import WatchConnectivity

class HeartRateManager: NSObject {
    private var healthStore = HKHealthStore()
    private var heartRateQuery: HKQuery?
    
    override init() {
        super.init()
        requestHealthKitAuthorization()
    }

    func requestHealthKitAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            return
        }

        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let typesToRead: Set<HKObjectType> = [heartRateType]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if success {
                self.startHeartRateMonitoring()
            } else {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func startHeartRateMonitoring() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: { _, samples, _, _, error in
            self.processHeartRateSamples(samples)
        })

        query.updateHandler = { _, samples, _, _, _ in
            self.processHeartRateSamples(samples)
        }

        healthStore.execute(query)
        heartRateQuery = query
    }

    private func processHeartRateSamples(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample],
              let mostRecentSample = heartRateSamples.last else {
            return
        }
        
        let heartRate = mostRecentSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
        // Update your UI with the heart rate here
        // For example, using NotificationCenter or another method
        NotificationCenter.default.post(name: NSNotification.Name("HeartRateUpdate"), object: heartRate)

    }
    private func sendHeartRateToPhone(heartRate: Double) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["heartRate": heartRate], replyHandler: nil) { error in
                print("Error sending heart rate: \(error.localizedDescription)")
            }
        }
    }

    
}
