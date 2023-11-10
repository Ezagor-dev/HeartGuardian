//
//  ContentView.swift
//  HeartGuardian
//
//  Created by Ezagor on 7.11.2023.
//

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
            
            if heartRate > 100 {
                Text("Yüksek Kalp Atış Hızı")
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
        // Zamanlayıcı oluştur ve her 10 saniyede bir ölçüm yap
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.fetchLatestHeartRateSample()
        }
    }
    
    func fetchLatestHeartRateSample() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let sample = results?.first as? HKQuantitySample {
                let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                self.heartRate = heartRate
                print("Son kalp atış hızı: \(heartRate) bpm")
                
                if heartRate > 100 {
                    print("Uyarı: Kalp atış hızı 100 bpm üzerinde!")
                }
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
