import SwiftUI

struct AnalysisConfigView: View {
    @State private var configs = [
        StrategyConfig(name: "默认配置", isActive: true),
        StrategyConfig(name: "期中冲刺配置", isActive: false),
    ]
    @State private var showNewConfig = false

    var body: some View {
        NavigationStack {
            List {
                Section("配置列表") {
                    ForEach(configs) { config in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(config.name).font(.headline)
                                Text(config.isActive ? "当前生效" : "未启用")
                                    .font(.caption)
                                    .foregroundStyle(config.isActive ? .green : .secondary)
                            }
                            Spacer()
                            if config.isActive {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                }

                Section("当前配置预览") {
                    VStack(alignment: .leading, spacing: 8) {
                        ConfigRow(label: "分析字段", value: "错误原因 / 薄弱点 / 相似题")
                        ConfigRow(label: "练习策略", value: "易:中:难 = 3:2:1")
                        ConfigRow(label: "分类标签", value: "按知识点细分")
                        ConfigRow(label: "周报推送", value: "每周一 9:00")
                    }
                }

                Section("自然语言配置") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("通过对话调整策略")
                            .font(.subheadline).bold()

                        Text("例如：「这学期重点抓二次函数和几何证明，调整分析策略」")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(10)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        HStack {
                            TextField("输入策略调整需求…", text: .constant(""))
                                .textFieldStyle(.roundedBorder)
                            Button("确认") { }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.small)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("AI 策略配置")
            .toolbar {
                Button("新建配置", systemImage: "plus") { }
            }
        }
    }
}

struct StrategyConfig: Identifiable {
    let id = UUID()
    let name: String
    let isActive: Bool
}

struct ConfigRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label).foregroundStyle(.secondary).frame(width: 80, alignment: .leading)
            Text(value).font(.subheadline)
            Spacer()
        }
    }
}
