//
//  ContentView.swift
//  HeartGuardianWatchApp Watch App
//
//  Created by Ezagor on 26.11.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var heartRate: Double = 0
    let heartRateManager = HeartRateManager()

    var body: some View {
        VStack {
            Text("Heart Rate")
                .font(.headline)

            Text("\(heartRate, specifier: "%.0f") BPM")
                .font(.title)

            // Additional UI components
        }
        .onAppear {
            // Subscribe to heart rate updates
            NotificationCenter.default.addObserver(forName: NSNotification.Name("HeartRateUpdate"), object: nil, queue: nil) { notification in
                if let heartRate = notification.object as? Double {
                    self.heartRate = heartRate
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

