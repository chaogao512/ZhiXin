import SwiftUI
import Charts

struct StudentDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    DailySuggestionCard()
                    StatsGrid()
                    SubjectMasteryChart()
                    TrendChart()
                    WeaknessTags()
                    RecentMistakes()
                }
                .padding()
            }
            .navigationTitle("学习概览")
        }
    }
}

struct DailySuggestionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("今日学习建议", systemImage: "lightbulb.fill")
                .font(.headline)
                .foregroundStyle(.tint)
            Text("你的二次函数知识点掌握度偏低（55%），建议先复习顶点式公式，然后完成 3 道相似题练习。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.tint.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct StatsGrid: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(title: "连续学习", value: "7 天", icon: "flame.fill", color: .orange)
            StatCard(title: "本周新增", value: "12 题", icon: "plus.circle.fill", color: .red)
            StatCard(title: "已掌握", value: "8 题", icon: "checkmark.circle.fill", color: .green)
            StatCard(title: "待办练习", value: "3 组", icon: "pencil.circle.fill", color: .blue)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title2).bold()
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct SubjectMasteryChart: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("学科掌握度").font(.headline)
            Chart {
                BarMark(x: .value("学科", "数学"), y: .value("掌握度", 0.55))
                    .foregroundStyle(.blue)
                BarMark(x: .value("学科", "语文"), y: .value("掌握度", 0.82))
                    .foregroundStyle(.green)
                BarMark(x: .value("学科", "英语"), y: .value("掌握度", 0.68))
                    .foregroundStyle(.orange)
                BarMark(x: .value("学科", "物理"), y: .value("掌握度", 0.73))
                    .foregroundStyle(.purple)
            }
            .chartYAxisLabel("掌握度")
            .frame(height: 180)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct TrendChart: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("近 7 天掌握度趋势").font(.headline)
            Chart {
                LineMark(x: .value("日期", "3/10"), y: .value("掌握度", 0.60))
                LineMark(x: .value("日期", "3/11"), y: .value("掌握度", 0.58))
                LineMark(x: .value("日期", "3/12"), y: .value("掌握度", 0.63))
                LineMark(x: .value("日期", "3/13"), y: .value("掌握度", 0.65))
                LineMark(x: .value("日期", "3/14"), y: .value("掌握度", 0.70))
                LineMark(x: .value("日期", "3/15"), y: .value("掌握度", 0.68))
                LineMark(x: .value("日期", "3/16"), y: .value("掌握度", 0.72))
            }
            .chartYScale(domain: 0...1)
            .frame(height: 160)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct WeaknessTags: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("薄弱点提醒").font(.headline)
            FlowLayout(spacing: 8) {
                ForEach(["二次函数顶点式 (55%)", "过去完成时 (68%)", "相似三角形判定 (70%)"], id: \.self) { tag in
                    Button(tag) { }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        .controlSize(.small)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct RecentMistakes: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("最近错题").font(.headline)
            ForEach(0..<3) { i in
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundStyle(.secondary)
                    Text(["数学 - 二次函数顶点式", "英语 - 过去完成时", "物理 - 牛顿第二定律"][i])
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
