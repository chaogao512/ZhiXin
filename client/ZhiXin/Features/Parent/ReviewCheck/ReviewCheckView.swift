import SwiftUI

struct ReviewCheckView: View {
    @State private var selectedChild = "张三"
    @State private var showPhotoCapture = false
    @State private var capturedImages: [UIImage] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    childSelector
                    weaknessSection
                    generateSection
                    photoSection
                }
                .padding()
            }
            .navigationTitle("复习检查")
        }
    }

    private var childSelector: some View {
        Menu {
            Button("张三") { selectedChild = "张三" }
            Button("李四") { selectedChild = "李四" }
        } label: {
            HStack {
                Text(selectedChild).font(.headline)
                Image(systemName: "chevron.down")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var weaknessSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("选择薄弱知识点出题").font(.headline)

            ForEach(["二次函数顶点式 (55%)", "过去完成时 (68%)", "相似三角形判定 (70%)"], id: \.self) { item in
                HStack {
                    Image(systemName: "circle")
                        .foregroundStyle(.secondary)
                    Text(item)
                    Spacer()
                }
                .padding(10)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Button("生成练习（5题）") { }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var generateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("生成的练习").font(.headline)

            VStack(alignment: .leading) {
                Text("二次函数专项练习").font(.subheadline).bold()
                Text("5 题 · 已保存，可打印")
                    .font(.caption).foregroundStyle(.secondary)
                HStack {
                    Button("查看") { }.buttonStyle(.bordered).controlSize(.small)
                    Button("打印") { }.buttonStyle(.bordered).controlSize(.small)
                }
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("孩子完成后拍照上传").font(.headline)

            if capturedImages.isEmpty {
                Button(action: { showPhotoCapture = true }) {
                    VStack(spacing: 8) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 40))
                        Text("拍照录入已完成的练习")
                        Text("系统将自动批改并对比之前掌握度")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(40)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            } else {
                Text("已拍摄 \(capturedImages.count) 张照片")
                Button("上传并批改") { }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
            }
        }
        .sheet(isPresented: $showPhotoCapture) {
            CameraView { image in
                capturedImages.append(image)
            }
        }
    }
}
