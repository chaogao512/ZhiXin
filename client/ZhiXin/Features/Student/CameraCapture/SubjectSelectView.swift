import SwiftUI
import UIKit

struct SubjectSelectView: View {
    let images: [UIImage]
    let annotations: [String: MarkMistakeView.MarkData]
    @State private var selectedSubject: String = ""
    @State private var subjects = ["数学", "语文", "英语", "物理", "化学", "生物", "历史", "地理", "政治"]

    var body: some View {
        VStack(spacing: 16) {
            Text("选择学科")
                .font(.title2).bold()

            Text("可手动选择，也可跳过让 AI 自动识别")
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                ForEach(subjects, id: \.self) { subject in
                    Button(action: { selectedSubject = subject }) {
                        Text(subject)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedSubject == subject ? Color.accentColor : Color.clear)
                            .foregroundStyle(selectedSubject == subject ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedSubject == subject ? Color.clear : Color.gray.opacity(0.3))
                            )
                    }
                }
            }
            .padding()

            Button("跳过，AI 自动识别") {
                selectedSubject = ""
            }
            .buttonStyle(.bordered)

            Spacer()

            NavigationLink {
                MistakeConfirmView(images: images, subjectID: selectedSubject)
            } label: {
                Label("确认并上传", systemImage: "icloud.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.tint)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .disabled(images.isEmpty)
        }
        .navigationTitle("确认学科")
    }
}
