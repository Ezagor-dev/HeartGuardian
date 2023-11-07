//
//  HeartGuardianApp.swift
//  HeartGuardian
//
//  Created by Ezagor on 7.11.2023.
//

import SwiftUI

@main
struct HeartGuardianApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
