import SwiftUI

struct MistakeListView: View {
    @State private var selectedSubject = "全部"
    @State private var searchText = ""
    @State private var subjects = ["全部", "数学", "语文", "英语", "物理", "化学"]
    @State private var sortBy: SortOption = .smart

    enum SortOption: String, CaseIterable {
        case smart = "智能排序"
        case date = "按时间"
        case subject = "按学科"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar
                sortBar
                mistakeList
            }
            .navigationTitle("错题本")
            .searchable(text: $searchText, prompt: "搜索错题内容")
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(subjects, id: \.self) { subject in
                    Button(subject) {
                        selectedSubject = subject
                    }
                    .buttonStyle(.bordered)
                    .tint(selectedSubject == subject ? Color.accentColor : Color.gray)
                    .controlSize(.small)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(.regularMaterial)
    }

    private var sortBar: some View {
        Picker("排序方式", selection: $sortBy) {
            ForEach(SortOption.allCases, id: \.self) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var mistakeList: some View {
        List {
            Section("数学 · 3 道待复习") {
                MistakeRow(subject: "数学", chapter: "二次函数", preview: "已知二次函数 y = ax² + bx + c...",
                          status: "已分析", mastery: 0.55, isMastered: false)
                MistakeRow(subject: "数学", chapter: "一元二次方程", preview: "解方程 x² - 5x + 6 = 0...",
                          status: "已分析", mastery: 0.72, isMastered: false)
                MistakeRow(subject: "数学", chapter: "相似三角形", preview: "如图，在△ABC中...",
                          status: "待分析", mastery: nil, isMastered: false)
            }
            Section("英语 · 1 道待复习") {
                MistakeRow(subject: "英语", chapter: "过去完成时", preview: "She ___ the book before...",
                          status: "已分析", mastery: 0.68, isMastered: true)
            }
        }
    }
}

struct MistakeRow: View {
    let subject: String
    let chapter: String
    let preview: String
    let status: String
    let mastery: Double?
    let isMastered: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(subject).font(.subheadline).bold()
                    Text(chapter).font(.caption).foregroundStyle(.secondary)
                }
                Text(preview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                HStack {
                    statusBadge
                    if isMastered {
                        Text("已掌握")
                            .font(.caption2)
                            .foregroundStyle(.green)
                    }
                    if let mastery {
                        Text("\(Int(mastery * 100))%")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var statusBadge: some View {
        Text(status)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(status == "已分析" ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
            .foregroundStyle(status == "已分析" ? .green : .orange)
            .clipShape(Capsule())
    }
}
