import SwiftUI
import Charts

struct MistakeAnalyticsView: View {
    @State private var selectedView: AnalyticView = .weakness
    @State private var selectedClass = "七年级一班"

    enum AnalyticView: String, CaseIterable {
        case weakness = "共性薄弱点"
        case distribution = "错误类型分布"
        case trend = "趋势变化"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("班级", selection: $selectedClass) {
                    Text("七年级一班").tag("七年级一班")
                    Text("七年级二班").tag("七年级二班")
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .padding(.vertical, 8)

                Picker("分析维度", selection: $selectedView) {
                    ForEach(AnalyticView.allCases, id: \.self) { view in
                        Text(view.rawValue).tag(view)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 16) {
                        switch selectedView {
                        case .weakness: weaknessView
                        case .distribution: distributionView
                        case .trend: trendView
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("全班错题分析")
            #if os(macOS)
            .safeAreaInset(edge: .top) {
                TeacherQueryBar()
            }
            #endif
        }
    }

    private var weaknessView: some View {
        Group {
            Chart {
                BarMark(x: .value("知识点", "二次函数图像"), y: .value("出错人数", 23))
                    .foregroundStyle(.red)
                BarMark(x: .value("知识点", "过去完成时"), y: .value("出错人数", 18))
                    .foregroundStyle(.orange)
                BarMark(x: .value("知识点", "文言文虚词"), y: .value("出错人数", 15))
                    .foregroundStyle(.yellow)
                BarMark(x: .value("知识点", "欧姆定律"), y: .value("出错人数", 12))
                    .foregroundStyle(.green)
                BarMark(x: .value("知识点", "化学方程式"), y: .value("出错人数", 10))
                    .foregroundStyle(.blue)
            }
            .frame(height: 220)

            VStack(alignment: .leading) {
                Text("共性薄弱点详情").font(.headline)
                ForEach(["二次函数图像平移 (23人)", "过去完成时 (18人)", "文言文虚词 (15人)"], id: \.self) { item in
                    HStack {
                        Image(systemName: "person.2").foregroundStyle(.secondary)
                        Text(item)
                        Spacer()
                        Button("查看学生") { }
                            .buttonStyle(.bordered).controlSize(.small)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var distributionView: some View {
        Chart {
            SectorMark(angle: .value("占比", 45))
                .foregroundStyle(.orange)
                .annotation { Text("粗心 45%") }
            SectorMark(angle: .value("占比", 35))
                .foregroundStyle(.red)
                .annotation { Text("知识点 35%") }
            SectorMark(angle: .value("占比", 20))
                .foregroundStyle(.blue)
                .annotation { Text("审题 20%") }
        }
        .frame(height: 250)
    }

    private var trendView: some View {
        Group {
            Chart {
                LineMark(x: .value("周", "第1周"), y: .value("错题数", 45))
                LineMark(x: .value("周", "第2周"), y: .value("错题数", 52))
                LineMark(x: .value("周", "第3周"), y: .value("错题数", 38))
                LineMark(x: .value("周", "第4周"), y: .value("错题数", 41))
            }
            .frame(height: 200)

            HStack {
                StatCard(title: "本周总错题", value: "41", icon: "number", color: .blue, compact: true)
                StatCard(title: "分析覆盖率", value: "89%", icon: "percent", color: .green, compact: true)
                StatCard(title: "平均掌握度", value: "67%", icon: "chart.bar", color: .orange, compact: true)
            }
        }
    }
}

struct TeacherQueryBar: View {
    @State private var query = ""

    var body: some View {
        HStack {
            Image(systemName: "sparkle.magnifyingglass")
                .foregroundStyle(.tint)
            TextField("提问：查看分析 / 调整策略 / 布置练习…", text: $query)
                .textFieldStyle(.plain)
            Button("查询") { }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
        }
        .padding(10)
        .background(.regularMaterial)
    }
}
