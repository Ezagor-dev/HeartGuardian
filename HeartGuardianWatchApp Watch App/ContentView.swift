//
//  ContentView.swift
//  HeartGuardianWatchApp Watch App
//
//  Created by Ezagor on 26.11.2023.
//and when I close the watchapp, data couldn't send to iphone. It should work background too.

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    
    let heartRateManager: HeartRateManager
    init() {
            let viewModel = HeartRateViewModel()
            self.heartRateManager = HeartRateManager(viewModel: viewModel)
        self._viewModel = StateObject(wrappedValue: viewModel)

        }
    var body: some View {
        VStack {
                    Text("Heart Rate: \(viewModel.heartRate, specifier: "%.0f") BPM")
                        .font(.title)
                        .padding()
                        .background(heartRateColor(for: viewModel.heartRate))
                .cornerRadius(10)

            // Additional UI components
        }
        .onAppear {
            heartRateManager.startHeartRateMonitoring()

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

