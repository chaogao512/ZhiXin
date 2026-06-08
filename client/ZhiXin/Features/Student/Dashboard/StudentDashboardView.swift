import SwiftUI
import Charts

struct StudentDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    SubjectMasteryChart()
                    RecentMistakesSection()
                    WeaknessHighlightView()
                }
                .padding()
            }
            .navigationTitle("学习概览")
        }
    }
}

struct SubjectMasteryChart: View {
    var body: some View {
        Chart {
            BarMark(x: .value("学科", "数学"), y: .value("掌握度", 0.72))
                .foregroundStyle(.blue)
            BarMark(x: .value("学科", "语文"), y: .value("掌握度", 0.85))
                .foregroundStyle(.green)
            BarMark(x: .value("学科", "英语"), y: .value("掌握度", 0.68))
                .foregroundStyle(.orange)
        }
        .frame(height: 200)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct RecentMistakesSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("最近错题").font(.headline)
            ForEach(0..<3) { _ in
                HStack {
                    Image(systemName: "doc.text")
                    Text("数学 - 二次函数")
                    Spacer()
                    Text("未分析").foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct WeaknessHighlightView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("薄弱点提醒").font(.headline)
            Label("英语 - 时态辨析", systemImage: "exclamationmark.triangle")
                .foregroundStyle(.orange)
            Label("数学 - 二次函数图像", systemImage: "exclamationmark.triangle")
                .foregroundStyle(.orange)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
