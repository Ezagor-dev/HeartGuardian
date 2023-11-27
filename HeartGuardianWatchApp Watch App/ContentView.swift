//
//  ContentView.swift
//  HeartGuardianWatchApp Watch App
//
//  Created by Ezagor on 26.11.2023.
//and when I close the watchapp, data couldn't send to iphone. It should work background too.

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
                .padding()
                .background(heartRateColor(for: heartRate))
                .cornerRadius(10)

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
    func heartRateColor(for heartRate: Double) -> Color {
        switch heartRate {
        case 0..<60:
            return .blue
        case 60..<90:
            return .green
        default:
            return .red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

