import SwiftUI

struct AccountPickerView: View {
    @Environment(UserManager.self) private var userManager
    @State private var showSetup = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // 品牌区域
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.gradient)
                        .frame(width: 80, height: 80)

                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(.white)
                }

                Text("知新")
                    .font(.system(size: 32, weight: .bold))

                Text("选择账户继续")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer().frame(height: 32)

            // 账户列表
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(userManager.savedAccounts, id: \.id) { account in
                        accountRow(account)
                    }
                }
                .padding(.horizontal, 24)
            }

            Spacer().frame(height: 16)

            // 添加新账户
            Button(action: { showSetup = true }) {
                Label("添加新账户", systemImage: "plus.circle")
                    .font(.body.weight(.medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundStyle(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 60)
        }
        .sheet(isPresented: $showSetup) {
            SetupView()
        }
    }

    private func accountRow(_ account: (id: String, name: String)) -> some View {
        HStack(spacing: 14) {
            // 头像
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 44, height: 44)

                Text(String(account.name.prefix(1)))
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.accentColor)
            }

            // 信息
            VStack(alignment: .leading, spacing: 2) {
                Text(account.name)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)
                Text(account.id.prefix(12) + "...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // 操作按钮
            Button("登录") {
                Task { await userManager.switchToAccount(id: account.id) }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)

            Button("删除") {
                userManager.removeSavedAccount(id: account.id)
            }
            .buttonStyle(.bordered)
            .tint(.red)
            .controlSize(.small)
        }
        .padding(14)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
