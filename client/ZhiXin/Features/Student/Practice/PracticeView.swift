import SwiftUI

struct PracticeView: View {
    @State private var selectedMode: PracticeMode = .single
    @State private var showAnswer = false
    @State private var selectedAnswer: String?
    @State private var currentQuestion = 0

    enum PracticeMode: String, CaseIterable {
        case single = "单题模式"
        case exam = "试卷模式"
    }

    let sampleQuestions = [
        QuestionData(question: "已知二次函数 y = 2(x-1)² + 3 的顶点坐标是？",
                    options: ["A. (1, 3)", "B. (-1, 3)", "C. (1, -3)", "D. (-1, -3)"],
                    correct: "A", explanation: "顶点式 y = a(x-h)² + k 的顶点为 (h, k)"),
        QuestionData(question: "函数 y = x² - 4x + 5 的最小值为？",
                    options: ["A. 1", "B. 2", "C. 3", "D. 5"],
                    correct: "A", explanation: "配方法：y = (x-2)² + 1，最小值为 1"),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("模式", selection: $selectedMode) {
                    ForEach(PracticeMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if selectedMode == .single {
                    singleModeView
                } else {
                    examModeView
                }
            }
            .navigationTitle("推荐练习")
        }
    }

    private var singleModeView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("第 \(currentQuestion + 1) 题 / 共 \(sampleQuestions.count) 题")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(sampleQuestions[currentQuestion].question)
                    .font(.body)

                ForEach(sampleQuestions[currentQuestion].options, id: \.self) { option in
                    Button(action: {
                        selectedAnswer = option
                        withAnimation { showAnswer = true }
                    }) {
                        Text(option)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(
                                selectedAnswer == option
                                    ? (option.hasPrefix(sampleQuestions[currentQuestion].correct)
                                        ? Color.green.opacity(0.2)
                                        : Color.red.opacity(0.2))
                                    : Color.clear
                            )
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(showAnswer)
                    .foregroundStyle(.primary)
                }

                if showAnswer {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("正确答案：\(sampleQuestions[currentQuestion].correct)",
                              systemImage: "checkmark.circle")
                            .foregroundStyle(.green)
                        Text(sampleQuestions[currentQuestion].explanation)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    if currentQuestion < sampleQuestions.count - 1 {
                        Button("下一题") {
                            currentQuestion += 1
                            showAnswer = false
                            selectedAnswer = nil
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    } else {
                        Text("已完成全部练习！")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
    }

    private var examModeView: some View {
        List {
            Section("待完成") {
                VStack(alignment: .leading) {
                    Text("二次函数专项练习")
                        .font(.subheadline).bold()
                    Text("5 题 · 预计 15 分钟")
                        .font(.caption).foregroundStyle(.secondary)
                }
                VStack(alignment: .leading) {
                    Text("英语时态每日练")
                        .font(.subheadline).bold()
                    Text("3 题 · 预计 10 分钟")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
            Section("已完成") {
                VStack(alignment: .leading) {
                    Text("一元二次方程基础")
                        .font(.subheadline).bold()
                    Text("5/5 正确 · 100%")
                        .font(.caption).foregroundStyle(.green)
                }
            }
            Section("练习历史") {
                Text("2024-03-15 二次函数基础 (4/5)")
                Text("2024-03-14 英语过去完成时 (3/3)")
                Text("2024-03-12 物理牛顿定律 (2/5)")
            }
        }
    }
}

struct QuestionData {
    let question: String
    let options: [String]
    let correct: String
    let explanation: String
}
