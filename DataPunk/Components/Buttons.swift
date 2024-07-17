//
//  Buttons.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/16.
//

import SwiftUI

import SwiftUI

struct IntroLargeButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold, design: .default))  // Larger and bold font
            .padding(.vertical, 20)
            .padding(.horizontal, 80)
            .background(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
            .cornerRadius(15)  // Slightly larger corner radius
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct ChevronButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack(alignment: .center) {
            configuration.label
                .padding(.horizontal, -5)
            Image(systemName: "chevron.right")
        }
        .foregroundColor(.accentColor)
        .font(.title2.weight(.medium))
        .listRowSeparator(.hidden)
    }
}
