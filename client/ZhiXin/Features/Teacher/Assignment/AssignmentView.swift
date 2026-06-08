import SwiftUI

struct AssignmentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("已布置") {
                    AssignmentCard(title: "二次函数专项练习", className: "七年级一班", dueDate: "2024-03-20")
                    AssignmentCard(title: "英语时态每日练", className: "七年级一班", dueDate: "2024-03-18")
                }
                Section("草稿") {
                    Text("文言文阅读理解")
                }
            }
            .navigationTitle("布置练习")
            .toolbar {
                Button("新建", systemImage: "plus") { }
            }
        }
    }
}

struct AssignmentCard: View {
    let title: String
    let className: String
    let dueDate: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.subheadline).bold()
            HStack {
                Label(className, systemImage: "person.3")
                Label(dueDate, systemImage: "calendar")
            }
            .font(.caption).foregroundStyle(.secondary)
        }
    }
}
