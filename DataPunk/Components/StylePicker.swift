//
//  StylePicker.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI

struct StylePicker: View {
    @Binding var contributeStyle: AppState.ContributeStyle
    
    let titles: [AppState.ContributeStyle: String] = [
        .intense: "热心的志愿者",
        .casual: "志愿者",
        .conservative: "谨慎的志愿者"
    ]
    
    let descriptions: [AppState.ContributeStyle: String] = [
        .intense: "你默认加入所有新的活动（在活动公布一天后），除非你决定退出",
        .casual: "你默认加入已加入的相关活动（在活动公布一天后）",
        .conservative: "你只加入你决定加入的活动"
    ]
    
    
    var body: some View {
        VStack{
            Text("选择你的风格")
                .font(.largeTitle)
                .bold()
            TextField("", text: .constant(descriptions[contributeStyle] ?? ""), axis: .vertical)
                .lineLimit(2...)
                .disabled(true)
                .font(.subheadline)
                .padding()
            Picker("Contribute Style", selection: $contributeStyle) {
                Text(titles[.intense]!).tag(AppState.ContributeStyle.intense)
                Text(titles[.casual]!).tag(AppState.ContributeStyle.casual)
                Text(titles[.conservative]!).tag(AppState.ContributeStyle.conservative)
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: 300)
        }
        .padding(.horizontal)
    }
}

#Preview {
    StylePicker(contributeStyle: .constant(.casual))
}
