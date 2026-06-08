import SwiftUI

struct CameraCaptureView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 64))
                    .foregroundStyle(.secondary)
                Text("拍摄错题")
                    .font(.title2)
                Text("对准题目，自动识别并分类")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("收集错题")
        }
    }
}
