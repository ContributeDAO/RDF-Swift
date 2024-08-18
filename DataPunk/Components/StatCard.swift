//
//  StatCard.swift
//  DataPunk
//
//  Created by 砚渤 on 8/18/24.
//

import SwiftUI

struct StatCard: View {
    var iconName: String
    var title: String
    var value: String?
    var showProgress: Bool = false
    var animationDelay: Double = 0.0 // 新增动画延迟参数
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.largeTitle)
            Text(title)
                .font(.largeTitle)
            Spacer()
            if showProgress {
                ProgressView()
                    .font(.title)
            } else if let value = value {
                Text(value)
                    .font(.title)
            } else {
                Text("--")
                    .foregroundColor(.secondary)
                    .font(.title)
            }
        }
        .padding(EdgeInsets(top: 20, leading: 16, bottom: 50, trailing: 16))
        .background(RandomGradientBackground())
        .shadow(color: .black.opacity(0.1), radius: 20)
        .offset(y: isVisible ? 0 : 300 + (100 * animationDelay)) // 初始偏移屏幕下方
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.spring(duration: 1.2 - animationDelay, bounce: 0.3).delay(animationDelay)) {
                isVisible = true
            }
        }
        .onDisappear {
            isVisible = false
        }
    }
}
