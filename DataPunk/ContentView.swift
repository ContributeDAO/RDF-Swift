//
//  ContentView.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI
import SwiftData

struct ContentView: View {
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
        if appState.experiencePhase == .finished {
            MainTabView()
        } else {
            VStack {
                switch appState.experiencePhase {
                case .onboarding:
                    Onboarding()
                case .styleSelection:
                    StylePicker(contributeStyle: Binding(
                        get: { appState.contributeStyle },
                        set: { appState.contributeStyle = $0 }
                    ))
                case .finished:
                    EmptyView()
                }
                Spacer()
                Button("Next") {
                    withAnimation {
                        switch appState.experiencePhase {
                        case .onboarding:
                            appState.experiencePhase = .styleSelection
                        case .styleSelection:
                            appState.experiencePhase = .finished
                        case .finished:
                            appState.experiencePhase = .onboarding
                        }
                        try! modelContext.save()
                    }
                }
                .buttonStyle(IntroLargeButtonStyle())
                .sensoryFeedback(.increase, trigger: appState.experiencePhase)
                .frame(idealWidth: 400, maxWidth: 500, idealHeight: 80, maxHeight: 100)
            }
            .padding(.top, 80)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: AppState.self, inMemory: true)
}
