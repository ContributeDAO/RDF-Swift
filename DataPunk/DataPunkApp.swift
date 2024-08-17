//
//  DataPunkApp.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI
import SwiftData

@main
struct DataPunkApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AppState.self,
            Campaign.self,
            DataPublished.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DeviceCheckModel())
                .onAppear {
                    _ = HealthIntegration.shared
                    Task {
                        _ = await initialiseWeb3()
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
