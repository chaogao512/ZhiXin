import SwiftUI
import PhotosUI

struct CameraCaptureView: View {
    @State private var capturedImages: [UIImage] = []
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var photoPickerItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                photoGrid

                HStack(spacing: 24) {
                    captureButton(icon: "camera.fill", label: "拍照") {
                        showCamera = true
                    }
                    captureButton(icon: "photo.on.rectangle", label: "相册") {
                        showPhotoPicker = true
                    }
                }
                .padding(.vertical)

                if !capturedImages.isEmpty {
                    NavigationLink {
                        MarkMistakeView(images: capturedImages)
                    } label: {
                        Label("下一步：标记错题", systemImage: "arrow.right")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.tint)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("收集错题")
            .fullScreenCover(isPresented: $showCamera) {
                CameraView { image in
                    capturedImages.append(image)
                }
            }
            .photosPicker(
                isPresented: $showPhotoPicker,
                selection: $photoPickerItem,
                matching: .images
            )
            .onChange(of: photoPickerItem) { _, item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        capturedImages.append(image)
                    }
                }
            }
        }
    }

    private var photoGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 12) {
                ForEach(capturedImages.indices, id: \.self) { index in
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: capturedImages[index])
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Button {
                            capturedImages.remove(at: index)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white, .black.opacity(0.6))
                                .padding(6)
                        }
                    }
                }
            }
            .padding()
        }
    }

    private func captureButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.largeTitle)
                Text(label)
                    .font(.caption)
            }
            .frame(width: 80, height: 80)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
