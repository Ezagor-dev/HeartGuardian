//
//  HeartGuardianApp.swift
//  HeartGuardian
//
//  Created by Ezagor on 7.11.2023.
//
import SwiftUI

@main
struct HeartGuardianApp: App {
    @State private var isActive = false

    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView() // Your main view
            } else {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Delay for 2 seconds
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
    }
}
