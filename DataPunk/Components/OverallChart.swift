import SwiftUI
import Charts

// Define a struct to hold your data
struct HealthData: Identifiable {
    var category: String
    var type: String
    var value: Double
    var id = UUID()
}

// Sample data for steps, heart rate, sleep, and activities
var healthData: [HealthData] = [
    .init(category: "Steps", type: "Activity A", value: 50),
    .init(category: "Steps", type: "Activity B", value: 65),
    .init(category: "Steps", type: "Activity C", value: 80),
    .init(category: "Heart Rate", type: "Activity A", value: 70),
    .init(category: "Heart Rate", type: "Activity B", value: 75),
    .init(category: "Heart Rate", type: "Activity C", value: 65),
    .init(category: "Sleep", type: "Activity A", value: 70),
    .init(category: "Sleep", type: "Activity B", value: 60),
    .init(category: "Sleep", type: "Activity C", value: 80)
]

struct OverallChart: View {
    var body: some View {
        Chart {
            ForEach(healthData) { data in
                BarMark(
                    x: .value("Activity Type", data.type),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(by: .value("Category", data.category))
            }
        }
        .chartLegend(position: .top)
    }
}

#Preview {
    OverallChart()
}
