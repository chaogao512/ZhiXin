import SwiftUI

struct AuthView: View {
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "book.closed.fill")
                .font(.system(size: 72))
                .foregroundStyle(.tint)

            Text("知新")
                .font(.largeTitle).bold()
            Text("温故而知新")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Button(action: { Task { try? await authManager.loginWithAppleID() } }) {
                Label("使用 Apple ID 登录", systemImage: "applelogo")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)

            Button(action: { Task { try? await authManager.loginWithWeChat() } }) {
                Label("使用微信登录", systemImage: "message.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)

            Spacer().frame(height: 48)
        }
    }
}
