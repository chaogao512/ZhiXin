import SwiftUI

struct SetupView: View {
    @Environment(UserManager.self) private var userManager
    @State private var name = ""
    @State private var role: UserRole = .student

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // 品牌区域
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.gradient)
                        .frame(width: 96, height: 96)

                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                }

                Text("知新")
                    .font(.system(size: 36, weight: .bold))

                Text("温故而知新")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // 输入卡片
            VStack(spacing: 20) {
                Text("欢迎使用")
                    .font(.title2).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 12) {
                    TextField("请输入你的姓名或昵称", text: $name)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("选择身份")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            roleButton(.student, icon: "pencil", color: .orange)
                            roleButton(.parent, icon: "heart", color: .blue)
                            roleButton(.teacher, icon: "star", color: .indigo)
                        }
                    }
                }
            }
            .padding(24)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal, 24)

            if let error = userManager.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, 12)
            }

            Spacer().frame(height: 24)

            // 开始按钮
            Button(action: submit) {
                HStack(spacing: 8) {
                    if userManager.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("开始使用")
                            .font(.body.weight(.semibold))
                        Image(systemName: "arrow.right")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    name.trimmingCharacters(in: .whitespaces).isEmpty
                        ? Color.gray.opacity(0.3)
                        : Color.accentColor
                )
                .foregroundColor(
                    name.trimmingCharacters(in: .whitespaces).isEmpty
                        ? .secondary
                        : .white
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || userManager.isLoading)
            .padding(.horizontal, 24)

            Spacer().frame(height: 60)
        }
    }

    private func roleButton(_ r: UserRole, icon: String, color: Color) -> some View {
        Button(action: { role = r }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)
                Text(r == .student ? "学生" : r == .parent ? "家长" : "教师")
                    .font(.caption.weight(.medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(role == r ? color.opacity(0.15) : Color(.systemGray6))
            .foregroundStyle(role == r ? color : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(role == r ? color : Color.clear, lineWidth: 2)
            )
        }
    }

    private func submit() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        Task { await userManager.createAccount(name: trimmed, role: role.rawValue) }
    }
}
