import SwiftUI

struct ClassManagementView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("我的班级") {
                    ClassCard(name: "七年级一班", subject: "数学", studentCount: 42)
                    ClassCard(name: "七年级二班", subject: "数学", studentCount: 38)
                }
            }
            .navigationTitle("班级管理")
            .toolbar {
                Button("创建班级", systemImage: "plus") { }
            }
        }
    }
}

struct ClassCard: View {
    let name: String
    let subject: String
    let studentCount: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(name).font(.headline)
            HStack {
                Label(subject, systemImage: "book")
                Label("\(studentCount) 人", systemImage: "person.3")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
