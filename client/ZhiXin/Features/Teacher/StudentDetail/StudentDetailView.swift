import SwiftUI
import Charts

struct StudentDetailView: View {
    let studentID: String
    @State private var showCommentEditor = false
    @State private var commentText = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                studentHeader
                subjectChart
                mistakeList
                teacherCommentSection
            }
            .padding()
        }
        .navigationTitle("学生详情")
        .sheet(isPresented: $showCommentEditor) {
            NavigationStack {
                VStack {
                    TextEditor(text: $commentText)
                        .padding()
                        .frame(minHeight: 150)
                    Text("此批注学生和家长端可见")
                        .font(.caption).foregroundStyle(.secondary)
                }
                .padding()
                .navigationTitle("教师批注")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("保存") { showCommentEditor = false }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("取消") { showCommentEditor = false }
                    }
                }
            }
        }
    }

    private var studentHeader: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.tint)
            VStack(alignment: .leading) {
                Text("张三").font(.title2).bold()
                HStack {
                    Label("七年级一班", systemImage: "book")
                    Label("共 23 道错题", systemImage: "exclamationmark.bubble")
                }
                .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Button("留言") { }
                .buttonStyle(.bordered)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var subjectChart: some View {
        VStack(alignment: .leading) {
            Text("各学科掌握度").font(.headline)
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
            .frame(height: 160)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var mistakeList: some View {
        VStack(alignment: .leading) {
            Text("最近错题").font(.headline)
            ForEach(0..<3) { i in
                NavigationLink {
                    MistakeDetailView(mistakeID: "")
                } label: {
                    HStack {
                        Image(systemName: "doc.text").foregroundStyle(.secondary)
                        Text(["数学 - 二次函数顶点式", "英语 - 过去完成时", "物理 - 牛顿第二定律"][i])
                        Spacer()
                        Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var teacherCommentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("教师批注").font(.headline)
            Button(action: { showCommentEditor = true }) {
                Label("添加批注", systemImage: "square.and.pencil")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            if !commentText.isEmpty {
                Text(commentText)
                    .font(.callout)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.yellow.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
