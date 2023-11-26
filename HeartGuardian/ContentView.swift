//  ContentView.swift
//  HeartGuardian
//
//  Created by Ezagor on 7.11.2023.
//10 seconds.

import SwiftUI
import HealthKit

struct ContentView: View {
    let healthStore = HKHealthStore()
    @State private var heartRate: Double = 0
    
    var body: some View {
        VStack {
            Text("Sağlık Takibi")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Image(systemName: "heart.fill")
                .font(.system(size: 100))
                .foregroundColor(.red)
                .padding()
            
            Text("Kalp Atış Hızı")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("\(heartRate, specifier: "%.0f") bpm")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if heartRate > 90 {
                Text("Yüksek Kalp Atış Hızı")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
            }else if heartRate < 50 && heartRate > 0{
                Text("Düşük Kalp Atış Hızı")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
            }else if heartRate == 0{
                Text("Bileklik Takılı Olmayabilir. \n\n0 Kalp Atış Hızı")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .onAppear {
            requestHealthKitAuthorization()
            startHeartRateMonitoring()
        }
    }
    
    func requestHealthKitAuthorization() {
        if HKHealthStore.isHealthDataAvailable() {
            let readTypes: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .heartRate)!]
            
            healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
                if success {
                    print("HealthKit izni alındı")
                } else {
                    print("HealthKit izni alınamadı veya bir hata oluştu: \(error?.localizedDescription ?? "Bilinmeyen Hata")")
                }
            }
        }
    }
    
    func startHeartRateMonitoring() {
        fetchLatestHeartRateSample()
    }
    
    func fetchLatestHeartRateSample() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Heart Rate Sample Type is unavailable.")
            return
        }

        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: { (query, samples, deletedObjects, anchor, error) in
            guard let samples = samples as? [HKQuantitySample], let mostRecentSample = samples.last else {
                print("Unable to query for heart rate: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            let heartRate = mostRecentSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            DispatchQueue.main.async {
                self.heartRate = heartRate
            }
        })

        query.updateHandler = { (query, samples, deletedObjects, anchor, error) in
            guard let samples = samples as? [HKQuantitySample], let mostRecentSample = samples.last else {
                return
            }
            
            let heartRate = mostRecentSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            DispatchQueue.main.async {
                self.heartRate = heartRate
            }
        }

        healthStore.execute(query)
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
