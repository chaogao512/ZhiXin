import SwiftUI

struct MistakeDetailView: View {
    let mistakeID: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PhotoSection()
                AnalysisResultSection()
                SimilarQuestionsSection()
            }
            .padding()
        }
        .navigationTitle("错题详情")
    }
}

struct PhotoSection: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.quaternary)
            .frame(height: 300)
            .overlay { Image(systemName: "photo").font(.largeTitle) }
    }
}

struct AnalysisResultSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("LLM 分析结果", systemImage: "sparkles.magnifyingglass")
                .font(.headline)
            InfoRow(label: "错误原因", value: "知识点不熟练")
            InfoRow(label: "正确解法", value: "使用顶点式公式...")
            InfoRow(label: "薄弱知识点", value: "二次函数图像变换")
            VStack(alignment: .leading) {
                Text("学习建议").font(.subheadline.bold())
                Text("建议先复习二次函数的三种表达形式，再练习图像平移相关习题。")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label).foregroundStyle(.secondary).frame(width: 80, alignment: .leading)
            Text(value)
            Spacer()
        }
    }
}

struct SimilarQuestionsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("推荐相似题", systemImage: "rectangle.stack")
                .font(.headline)
            SimilarQuestionCard()
            SimilarQuestionCard()
        }
    }
}

struct SimilarQuestionCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("已知二次函数 y = ax² + bx + c 的图像经过点 (0,1)...")
                .lineLimit(3)
            HStack {
                Button("查看答案") { }
                    .buttonStyle(.bordered)
                Button("已掌握") { }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
