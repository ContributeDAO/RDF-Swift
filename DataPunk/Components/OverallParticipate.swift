//
//  OverallParticipate.swift
//  DataPunk
//
//  Created by 砚渤 on 2024/7/17.
//

import SwiftUI

struct OverallParticipate: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<5, id: \.self) { i in
                    Rectangle()
                        .frame(width: 140, height: 200)
                        .overlay(RandomGradientBackground())
                        .overlay(
                            VStack {
                                Text("项目 \(String(i))")
                                    .font(.title)
                                    .bold()
                                Text("something 2 say here")
                                    .font(.subheadline)
                            }
                                .padding()
                        )
                        .rotation3DEffect(.degrees(2), axis: (x: 1, y: 0.7, z: 0.1))
                        .shadow(radius: 10, x: 0, y: 10)
                        .scaleEffect(0.8)
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    OverallParticipate()
}
