//
//  MyData.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import SwiftUI
import SwiftData

struct MyData: View {
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
        NavigationStack {
                List {
                    Section {
                        HStack(alignment: .center) {
                            Text("数据使用")
                                .font(.title.weight(.semibold))
                            Spacer()
                            Button("明细") {
                                
                            }
                            .buttonStyle(ChevronButtonStyle())
                        }
                        .listRowSeparator(.hidden)
                        OverallChart()
                            .frame(height: 200)
                    }
                    .padding(5)
                    Section {
                        HStack(alignment: .center) {
                            Text("加入活动记录")
                                .font(.title.weight(.semibold))
                            Spacer()
                            Button("明细") {
                                
                            }
                            .buttonStyle(ChevronButtonStyle())
                        }
                        .listRowSeparator(.hidden)
                        OverallParticipate()
                            .padding(-25)
                    }
                    .padding(5)
                    Section {
                        Button("Start over") {
                            appState.experiencePhase = .onboarding
                            try! modelContext.save()
                        }
                    }
                }
                .listSectionSpacing(10)
            .navigationTitle("我的数据")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

#Preview {
    MyData()
}
