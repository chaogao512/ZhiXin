import SwiftUI

struct ProfileView: View {
    @Environment(UserManager.self) private var userManager
    @State private var showJoinClass = false
    @State private var inviteCode = ""
    @State private var showBindParent = false
    @State private var showConfirmLogout = false

    var body: some View {
        NavigationStack {
            List {
                Section("个人信息") {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.accentColor.opacity(0.15))
                                .frame(width: 52, height: 52)

                            Text(String(userManager.currentUser?.name.prefix(1) ?? "用"))
                                .font(.title2.weight(.semibold))
                                .foregroundStyle(Color.accentColor)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(userManager.currentUser?.name ?? "用户")
                                .font(.headline)

                            HStack(spacing: 6) {
                                roleBadge(userManager.currentUser?.role ?? "")
                                Text("ID: " + userManager.userId.prefix(12) + "...")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("班级") {
                    Button(action: { showJoinClass = true }) {
                        Label("加入班级", systemImage: "person.badge.plus")
                    }
                }

                Section("家长绑定") {
                    Button(action: { showBindParent = true }) {
                        Label("生成家长绑定码", systemImage: "qrcode")
                    }
                }

                Section("统计分析") {
                    NavigationLink("学习统计") { Text("学习统计") }
                    NavigationLink("导出数据") { Text("导出数据") }
                }

                Section {
                    Button(role: .destructive) {
                        showConfirmLogout = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("退出登录")
                                .font(.body.weight(.medium))
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("我的")
            .alert("退出登录", isPresented: $showConfirmLogout) {
                Button("退出", role: .destructive) { userManager.logout() }
                Button("取消", role: .cancel) {}
            } message: {
                Text("退出后可在账户列表重新选择此账户")
            }
            .sheet(isPresented: $showJoinClass) {
                NavigationStack {
                    VStack(spacing: 16) {
                        Text("输入班级邀请码")
                            .font(.headline)
                        TextField("请输入 6 位班级码", text: $inviteCode)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            .frame(width: 200)
                        Button("加入") { }
                            .buttonStyle(.borderedProminent)
                            .disabled(inviteCode.count != 6)
                    }
                    .padding()
                    .navigationTitle("加入班级")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("取消") { showJoinClass = false }
                        }
                    }
                }
            }
        }
    }

    private func roleBadge(_ role: String) -> some View {
        let label: String
        let color: Color
        switch role {
        case "student": label = "学生"; color = .orange
        case "parent": label = "家长"; color = .blue
        case "teacher": label = "教师"; color = .indigo
        default: label = role; color = .gray
        }
        return Text(label)
            .font(.caption2.weight(.medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color.opacity(0.12))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
