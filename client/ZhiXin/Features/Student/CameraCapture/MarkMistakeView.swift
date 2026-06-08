import SwiftUI
import PencilKit

struct MarkMistakeView: View {
    let images: [UIImage]
    @State private var currentIndex = 0
    @State private var annotations: [String: MarkData] = [:]
    @State private var showVoiceInput = false
    @State private var showTextInput = false
    @State private var voiceNoteText = ""
    @State private var textNote = ""

    struct MarkData: Codable {
        var drawingData: Data?
        var voiceNote: String?
        var textNote: String?
    }

    var body: some View {
        VStack(spacing: 12) {
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    CanvasView(image: images[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .frame(height: 350)

            HStack(spacing: 20) {
                markButton(icon: "pencil.tip", label: "圈画", color: .blue) {
                }
                markButton(icon: "mic.fill", label: "语音", color: .green) {
                    showVoiceInput = true
                }
                markButton(icon: "text.alignleft", label: "文字", color: .orange) {
                    showTextInput = true
                }
            }

            if !textNote.isEmpty {
                Text(textNote)
                    .font(.callout)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
            }

            Spacer()

            NavigationLink {
                SubjectSelectView(images: images, annotations: annotations)
            } label: {
                Label("下一步：选择学科", systemImage: "arrow.right")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.tint)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
        }
        .navigationTitle("标记错题 (\(currentIndex + 1)/\(images.count))")
        .sheet(isPresented: $showVoiceInput) {
            VoiceInputView(text: $voiceNoteText)
        }
        .sheet(isPresented: $showTextInput) {
            TextInputView(text: $textNote)
        }
    }

    private func markButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon).font(.title3)
                Text(label).font(.caption2)
            }
            .frame(width: 70, height: 60)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct CanvasView: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        canvas.addSubview(imageView)
        imageView.frame = canvas.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

struct VoiceInputView: View {
    @Binding var text: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "mic.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.tint)
                Text("点击录音，描述这道错题的情况")
                    .foregroundStyle(.secondary)
                Button("开始录音") { }
                    .buttonStyle(.borderedProminent)
                if !text.isEmpty {
                    Text("识别结果：\(text)")
                        .padding()
                }
            }
            .padding()
            .navigationTitle("语音输入")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

struct TextInputView: View {
    @Binding var text: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $text)
                    .padding()
                    .frame(minHeight: 200)
                Text("描述错题信息，如：这是第3题，我选错了答案")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("文字备注")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}
