//
//  DeviceCheck.swift
//  DataPunk
//
//  Created by 砚渤 on 8/17/24.
//

import SwiftUI
import DeviceCheck

struct DeviceCheckView: View {
    @EnvironmentObject var deviceCheckModel: DeviceCheckModel
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(deviceCheckModel.statusColor)
            VStack(alignment: .leading, spacing: 5) {
                Text("设备检查")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(deviceCheckModel.statusText)
            }
            .padding(.vertical)
        }
    }
    
}

struct DeviceCheckView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceCheckView()
    }
}
