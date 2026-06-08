import SwiftUI

struct AssignmentView: View {
    @State private var showCreate = false

    var body: some View {
        NavigationStack {
            List {
                Section("已发布") {
                    AssignmentCard(title: "二次函数专项练习", className: "七年级一班",
                                  stats: "23/42 已完成 · 正确率 71%")
                    AssignmentCard(title: "过去完成时每日练", className: "七年级一班",
                                  stats: "18/42 已完成 · 正确率 82%")
                }

                Section("草稿") {
                    Text("文言文阅读理解 (5题)")
                    Text("物理欧姆定律 (3题)")
                }

                Section("历史发布") {
                    Text("2024-03-10 一元二次方程 (5题)")
                    Text("2024-03-05 英语时态综合 (8题)")
                }
            }
            .navigationTitle("布置练习")
            .toolbar {
                Button("新建", systemImage: "plus") { showCreate = true }
            }
            .sheet(isPresented: $showCreate) {
                CreateAssignmentView()
            }
        }
    }
}

struct AssignmentCard: View {
    let title: String
    let className: String
    let stats: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.subheadline).bold()
            Label(className, systemImage: "person.3")
                .font(.caption).foregroundStyle(.secondary)
            Text(stats)
                .font(.caption).foregroundStyle(.green)
        }
        .padding(.vertical, 4)
    }
}

struct CreateAssignmentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var mode: AssignmentMode = .fromMistakes
    @State private var selectedSubjects: Set<String> = []
    @State private var scope: AssignmentScope = .class

    enum AssignmentMode: String, CaseIterable {
        case fromMistakes = "从错题生成"
        case custom = "自定义出题"
    }

    enum AssignmentScope: String, CaseIterable {
        case `class` = "全班"
        case individual = "指定学生"
        case weakness = "按薄弱点"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("出题方式") {
                    Picker("模式", selection: $mode) {
                        ForEach(AssignmentMode.allCases, id: \.self) { m in
                            Text(m.rawValue).tag(m)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if mode == .fromMistakes {
                    Section("选择知识点") {
                        ForEach(["二次函数", "过去完成时", "相似三角形", "欧姆定律"], id: \.self) { item in
                            HStack {
                                Text(item)
                                Spacer()
                                if selectedSubjects.contains(item) {
                                    Image(systemName: "checkmark")
                            }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedSubjects.contains(item) {
                                    selectedSubjects.remove(item)
                                } else {
                                    selectedSubjects.insert(item)
                                }
                            }
                        }
                    }
                } else {
                    Section("题目要求") {
                        TextField("知识点", text: .constant(""))
                        TextField("难度（如：易:中:难 = 3:2:1）", text: .constant(""))
                        TextField("题型偏好（可选）", text: .constant(""))
                    }
                }

                Section("发布范围") {
                    Picker("范围", selection: $scope) {
                        ForEach(AssignmentScope.allCases, id: \.self) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }
                }

                Section {
                    Button("生成并发布") { dismiss() }
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("新建练习")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
            }
        }
    }
}
