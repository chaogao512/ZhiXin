import SwiftUI

struct ManualEntryView: View {
    @State private var subjectID = ""
    @State private var chapterName = ""
    @State private var questionText = ""
    @State private var studentAnswer = ""
    @State private var correctAnswer = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    Picker("学科", selection: $subjectID) {
                        Text("请选择").tag("")
                        Text("数学").tag("math")
                        Text("语文").tag("chinese")
                        Text("英语").tag("english")
                        Text("物理").tag("physics")
                    }
                    TextField("章节（可选）", text: $chapterName)
                }

                Section("题目内容") {
                    TextEditor(text: $questionText)
                        .frame(minHeight: 120)
                    Text("请输入题目原文")
                        .font(.caption).foregroundStyle(.secondary)
                }

                Section("答案") {
                    TextEditor(text: $studentAnswer)
                        .frame(minHeight: 60)
                    Text("你的答案")
                        .font(.caption).foregroundStyle(.secondary)

                    TextEditor(text: $correctAnswer)
                        .frame(minHeight: 60)
                    Text("正确答案")
                        .font(.caption).foregroundStyle(.secondary)
                }

                Section {
                    Button("提交并分析") { }
                        .frame(maxWidth: .infinity)
                        .disabled(questionText.isEmpty || studentAnswer.isEmpty || correctAnswer.isEmpty)
                }
            }
            .navigationTitle("手动录入")
        }
    }
}
