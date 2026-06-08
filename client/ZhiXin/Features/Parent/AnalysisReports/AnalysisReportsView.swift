import SwiftUI
import Charts

struct AnalysisReportsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("本周报告") {
                    ReportRow(title: "数学薄弱点分析", date: "2024-03-15")
                    ReportRow(title: "英语时态专项报告", date: "2024-03-14")
                }
                Section("历史报告") {
                    ReportRow(title: "月度学习总结 - 2月", date: "2024-03-01")
                    ReportRow(title: "期中考试分析", date: "2024-02-20")
                }
            }
            .navigationTitle("分析报告")
        }
    }
}

struct ReportRow: View {
    let title: String
    let date: String

    var body: some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .foregroundStyle(.tint)
            VStack(alignment: .leading) {
                Text(title).font(.subheadline)
                Text(date).font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
