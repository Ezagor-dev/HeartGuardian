//  ContentView.swift
//  HeartGuardian
//
//  Created by Ezagor on 7.11.2023.
//10 seconds.

import SwiftUI

struct ContentView: View {
    @ObservedObject var heartRateObservable = WCSessionManager.shared.heartRateObservable

    var body: some View {
        VStack {
            Text("Heart Rate: \(heartRateObservable.heartRate, specifier: "%.0f") BPM")
                .font(.title)
                .padding()
                .background(heartRateColor(for: heartRateObservable.heartRate))
                .cornerRadius(10)
            
            // Additional UI components can go here
        }
        .onAppear {
            // Ensuring WCSessionManager is initialized
            _ = WCSessionManager.shared
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
