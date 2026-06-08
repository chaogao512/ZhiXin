import SwiftUI

struct MistakeConfirmView: View {
    let images: [UIImage]
    let subjectID: String?
    @State private var isUploading = false
    @State private var uploadComplete = false
    @State private var uploadProgress: Double = 0

    var body: some View {
        VStack(spacing: 24) {
            if uploadComplete {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(.green)

                Text("上传完成！")
                    .font(.title2).bold()

                Text("AI 正在分析你的错题，分析完成后会通知你")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                NavigationLink("返回首页", destination: StudentDashboardView())
                    .buttonStyle(.borderedProminent)

            } else {
                ProgressView(value: uploadProgress) {
                    Text(isUploading ? "正在上传 \(Int(uploadProgress * 100))%" : "准备上传...")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()

                if !isUploading {
                    Button("开始上传") {
                        startUpload()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
        }
        .padding()
        .navigationTitle("确认上传")
        .navigationBarBackButtonHidden(isUploading)
    }

    private func startUpload() {
        isUploading = true
        Task {
            for i in images.indices {
                try? await Task.sleep(nanoseconds: 500_000_000)
                uploadProgress = Double(i + 1) / Double(images.count)
            }
            uploadProgress = 1
            uploadComplete = true
            isUploading = false
        }
    }
}
