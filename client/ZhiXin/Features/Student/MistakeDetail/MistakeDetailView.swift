import SwiftUI

struct MistakeDetailView: View {
    let mistakeID: String
    @State private var isMastered = false
    @State private var showRemarkEditor = false
    @State private var remarkText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                photoSection
                analysisSection
                weaknessSection
                similarQuestionsSection
                actionSection
            }
            .padding()
        }
        .navigationTitle("错题详情")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("重新分析") { }
            }
        }
    }

    private var photoSection: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.quaternary)
            .frame(height: 280)
            .overlay {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            }
    }

    private var analysisSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label {
                Text("AI 分析结果").font(.headline)
            } icon: {
                Image(systemName: "sparkles.magnifyingglass")
                    .foregroundStyle(.tint)
            }

            VStack(alignment: .leading, spacing: 8) {
                detailRow(label: "错误原因", value: "二次函数顶点式公式记忆不牢固")
                Divider()
                detailRow(label: "正确解法", value: "使用顶点式公式 y = a(x-h)² + k...")
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text("掌握度评估")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    ProgressView(value: 0.55)
                        .tint(.orange)
                    Text("55%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text("学习建议").font(.subheadline).foregroundStyle(.secondary)
                    Text("建议先复习二次函数的三种表达形式（一般式、顶点式、交点式），再练习图像平移相关习题。")
                        .font(.callout)
                }
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var weaknessSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("薄弱知识点").font(.headline)
            FlowLayout(spacing: 8) {
                ForEach(["二次函数顶点式", "函数图像平移", "配方法"], id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.red.opacity(0.1))
                        .foregroundStyle(.red)
                        .clipShape(Capsule())
                }
            }
        }
    }

    private var similarQuestionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("相似题推荐").font(.headline)
            ForEach(0..<3) { i in
                VStack(alignment: .leading, spacing: 8) {
                    Text("已知二次函数 y = ax² + bx + c 的图像经过点 (0,1) 和 (2,5)...")
                        .lineLimit(3)
                        .font(.subheadline)
                    HStack {
                        Button("查看答案") { }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        Button("开始练习") { }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                    }
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var actionSection: some View {
        VStack(spacing: 12) {
            Toggle(isOn: $isMastered) {
                Label("标记为已掌握", systemImage: "checkmark.circle")
            }
            .tint(.green)

            Button(action: { showRemarkEditor = true }) {
                Label("添加备注", systemImage: "square.and.pencil")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .sheet(isPresented: $showRemarkEditor) {
            NavigationStack {
                TextEditor(text: $remarkText)
                    .padding()
                    .navigationTitle("个人备注")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("保存") { showRemarkEditor = false }
                        }
                    }
            }
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.subheadline).foregroundStyle(.secondary)
            Text(value).font(.callout)
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 300
        var height: CGFloat = 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxRowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if currentX + size.width > width {
                currentX = 0
                currentY += maxRowHeight + spacing
                maxRowHeight = 0
            }
            currentX += size.width + spacing
            maxRowHeight = max(maxRowHeight, size.height)
        }
        height = currentY + maxRowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var maxRowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += maxRowHeight + spacing
                maxRowHeight = 0
            }
            view.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
            currentX += size.width + spacing
            maxRowHeight = max(maxRowHeight, size.height)
        }
    }
}
