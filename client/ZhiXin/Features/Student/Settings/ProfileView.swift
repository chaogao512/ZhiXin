import SwiftUI

struct ProfileView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var showJoinClass = false
    @State private var inviteCode = ""
    @State private var showBindParent = false

    var body: some View {
        NavigationStack {
            List {
                Section("账号信息") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.tint)
                        VStack(alignment: .leading) {
                            Text(authManager.currentUser?.name ?? "用户")
                                .font(.headline)
                            Text(authManager.currentUser?.role ?? "")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("班级") {
                    Button(action: { showJoinClass = true }) {
                        Label("加入班级", systemImage: "person.badge.plus")
                    }
                    if !inviteCode.isEmpty {
                        Text("已加入班级").foregroundStyle(.secondary)
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
                        authManager.logout()
                    } label: {
                        Label("退出登录", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("我的")
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
}
