import SwiftUI
import Charts

struct ChildDashboardView: View {
    @State private var selectedChild = "张三"
    @State private var children = ["张三", "李四"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    childPicker
                    snapshotContent
                }
                .padding()
            }
            .navigationTitle("学习概览")
            #if os(macOS)
            .safeAreaInset(edge: .top) {
                QueryBar()
            }
            #endif
        }
    }

    private var childPicker: some View {
        Menu {
            ForEach(children, id: \.self) { child in
                Button(child) { selectedChild = child }
            }
        } label: {
            HStack {
                Text(selectedChild).font(.headline)
                Image(systemName: "chevron.down")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    @ViewBuilder
    private var snapshotContent: some View {
        #if os(iOS)
        iOSSnapshotView()
        #elseif os(macOS)
        macOSSidebarView()
        #else
        iPadDetailedView()
        #endif
    }
}

struct iOSSnapshotView: View {
    var body: some View {
        Group {
            Chart {
                RadarChartEntry()
            }
            .frame(height: 200)

            HStack {
                StatCard(title: "本周错题", value: "12", icon: "exclamationmark.circle", color: .red, compact: true)
                StatCard(title: "掌握度", value: "72%", icon: "chart.pie", color: .blue, compact: true)
            }

            VStack(alignment: .leading) {
                Text("薄弱点").font(.headline)
                FlowLayout(spacing: 6) {
                    ForEach(["二次函数", "过去完成时", "相似三角形"], id: \.self) { tag in
                        Text(tag).font(.caption).padding(6)
                            .background(.red.opacity(0.1)).foregroundStyle(.red).clipShape(Capsule())
                    }
                }
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct iPadDetailedView: View {
    var body: some View {
        Group {
            Chart {
                BarMark(x: .value("学科", "数学"), y: .value("掌握度", 0.55))
                    .foregroundStyle(.blue)
                BarMark(x: .value("学科", "语文"), y: .value("掌握度", 0.82))
                    .foregroundStyle(.green)
                BarMark(x: .value("学科", "英语"), y: .value("掌握度", 0.68))
                    .foregroundStyle(.orange)
            }
            .frame(height: 200)

            Chart {
                LineMark(x: .value("日期", "3/10"), y: .value("掌握度", 0.60))
                LineMark(x: .value("日期", "3/11"), y: .value("掌握度", 0.58))
                LineMark(x: .value("日期", "3/14"), y: .value("掌握度", 0.65))
                LineMark(x: .value("日期", "3/16"), y: .value("掌握度", 0.72))
            }
            .frame(height: 160)

            VStack(alignment: .leading) {
                Text("AI 分析摘要").font(.headline)
                Text("本周数学错题主要集中在二次函数章节（5题），建议重点复习顶点式和配方法。英语过去完成时正确率有提升（从 60% → 75%）。")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct macOSSidebarView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("最近动态").font(.headline)
            ForEach(0..<5) { i in
                HStack {
                    Circle().fill([.blue, .green, .orange, .red, .purple][i]).frame(width: 8)
                    Text([
                        "张三上传了 3 道数学错题",
                        "LLM 完成了英语错题分析",
                        "张三完成了二次函数练习（4/5正确）",
                        "本周学习报告已生成",
                        "英语薄弱点有新进展"][i])
                    Spacer()
                    Text(["2小时前", "4小时前", "昨天", "昨天", "3天前"][i])
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct RadarChartEntry: ChartContent {
    var body: some ChartContent {
        BarMark(x: .value("学科", "数学"), y: .value("掌握度", 0.55))
        BarMark(x: .value("学科", "英语"), y: .value("掌握度", 0.68))
        BarMark(x: .value("学科", "语文"), y: .value("掌握度", 0.82))
        BarMark(x: .value("学科", "物理"), y: .value("掌握度", 0.73))
    }
}

struct QueryBar: View {
    @State private var query = ""

    var body: some View {
        HStack {
            Image(systemName: "sparkle.magnifyingglass")
                .foregroundStyle(.tint)
            TextField("输入问题，了解孩子的学习情况…", text: $query)
                .textFieldStyle(.plain)
            Button("查询") { }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
        }
        .padding(10)
        .background(.regularMaterial)
    }
}
