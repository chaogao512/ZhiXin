import SwiftUI

struct ClassManagementView: View {
    @State private var classes = [
        ClassItem(name: "七年级一班", subject: "数学", grade: "七年级", studentCount: 42),
        ClassItem(name: "七年级二班", subject: "数学", grade: "七年级", studentCount: 38),
    ]
    @State private var showCreateClass = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(classes) { cls in
                    NavigationLink {
                        ClassDetailView(cls: cls)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(cls.name).font(.headline)
                            HStack {
                                Label(cls.subject, systemImage: "book")
                                Label(cls.grade, systemImage: "graduationcap")
                                Label("\(cls.studentCount)人", systemImage: "person.3")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete { _ in }
            }
            .navigationTitle("班级管理")
            .toolbar {
                Button("创建班级", systemImage: "plus") {
                    showCreateClass = true
                }
            }
            .sheet(isPresented: $showCreateClass) {
                CreateClassView()
            }
        }
    }
}

struct ClassItem: Identifiable {
    let id = UUID()
    let name: String
    let subject: String
    let grade: String
    let studentCount: Int
}

struct ClassDetailView: View {
    let cls: ClassItem
    @State private var inviteCode = "ABC123"

    var body: some View {
        List {
            Section("班级信息") {
                HStack {
                    Text("邀请码")
                    Spacer()
                    Text(inviteCode)
                        .foregroundStyle(.tint)
                    Button("重置") { }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                }
            }

            Section("学生列表 (42人)") {
                ForEach(0..<5) { i in
                    HStack {
                        Image(systemName: "person.circle")
                        VStack(alignment: .leading) {
                            Text(["张三", "李四", "王五", "赵六", "钱七"][i])
                            Text("错题 12 题 · 掌握度 72%")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("详情") { }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                    }
                }
            }

            Section {
                Button("批量邀请家长") { }
                Button("导出班级数据") { }
            }
        }
        .navigationTitle(cls.name)
    }
}

struct CreateClassView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var subject = "数学"
    @State private var grade = "七年级"

    var body: some View {
        NavigationStack {
            Form {
                TextField("班级名称", text: $name)
                Picker("学科", selection: $subject) {
                    Text("数学").tag("数学")
                    Text("语文").tag("语文")
                    Text("英语").tag("英语")
                }
                Picker("年级", selection: $grade) {
                    Text("七年级").tag("七年级")
                    Text("八年级").tag("八年级")
                    Text("九年级").tag("九年级")
                }
                Section {
                    Button("创建") { dismiss() }
                        .frame(maxWidth: .infinity)
                        .disabled(name.isEmpty)
                }
            }
            .navigationTitle("创建班级")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
            }
        }
    }
}
