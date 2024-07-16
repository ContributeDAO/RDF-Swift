//
//  MainTabView.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var appStates: [AppState]
    
    private var appState: AppState {
        if appStates.isEmpty {
            modelContext.insert(AppState())
            try! modelContext.save()
        }
        return appStates.first!
    }
    
    var body: some View {
        TabView() {
            CompaignGallery()
                .tabItem {
                    Label("活动募集", systemImage: "flag.filled.and.flag.crossed")
                }
            Button("Start over") {
                appState.experiencePhase = .onboarding
                try! modelContext.save()
            }
                .tabItem {
                    Label("我的数据", systemImage: "person.and.background.dotted")
                }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: AppState.self, inMemory: true)
}
