//
//  MainTabView.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView() {
            CompaignGallery()
                .tabItem {
                    Label("活动募集", systemImage: "flag.filled.and.flag.crossed")
                }
            MyData()
                .tabItem {
                    Label("我的数据", systemImage: "person.and.background.dotted")
                }
        }
    }
}

#Preview {
    MainTabView()
}
