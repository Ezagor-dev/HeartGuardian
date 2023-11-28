//
//  LaunchScreenView.swift
//  HeartGuardian
//
//  Created by Ezagor on 28.11.2023.
//launchscreen

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Image("launchscreen")
                .resizable()
                .scaledToFill() // Use scaledToFit to maintain the image's aspect ratio
                 // Set the frame as needed
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
                 // Ignore safe area to have a full-screen background
            
            VStack {
                // Pushes the content to the center
                
                Image("launchscreen") // Replace with the name of your launch image in the assets
                    .resizable()
                    .scaledToFit() // Use scaledToFit to maintain the image's aspect ratio
                     // Set the frame as needed
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)

                
                // Pushes the content to the center
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
