//
//  HeartRateManager.swift
//  HeartGuardianWatchApp Watch App
//
//  Created by Ezagor on 26.11.2023.
//

import HealthKit
import WatchConnectivity

class HeartRateManager: NSObject, WCSessionDelegate {
    private var healthStore = HKHealthStore()
    private var heartRateQuery: HKQuery?
    var viewModel: HeartRateViewModel
    
    init(viewModel: HeartRateViewModel) {
            self.viewModel = viewModel
            super.init()
            if WCSession.isSupported() {
                WCSession.default.delegate = self
                WCSession.default.activate()
            }
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
            guard HKHealthStore.isHealthDataAvailable() else {
                print("HealthKit is not available on this device.")
                return
            }

            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { [weak self] _, samples, _, _, error in
                if let error = error {
                    print("Error starting heart rate monitoring: \(error.localizedDescription)")
                    return
                }
                self?.processHeartRateSamples(samples)
            }

            query.updateHandler = { [weak self] _, samples, _, _, _ in
                self?.processHeartRateSamples(samples)
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
        DispatchQueue.main.async {
            print("Fetched heart rate: \(heartRate)")
            
            self.viewModel.heartRate = heartRate
            self.sendHeartRateToPhone(heartRate: heartRate)
            //print("Updated ViewModel heart rate to: \(heartRate)")

        }
    }

    
    
    private func sendHeartRateToPhone(heartRate: Double) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["heartRate": heartRate], replyHandler: nil) { error in
                print("Error sending heart rate: \(error.localizedDescription)")
            }
        }
    }
    // WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
           if let error = error {
               print("WCSession activation failed with error: \(error.localizedDescription)")
               return
           }
           print("WCSession activated with state: \(activationState.rawValue)")

        startHeartRateMonitoring()
           // Optionally start heart rate monitoring here or elsewhere as needed
       }

    

    
}
