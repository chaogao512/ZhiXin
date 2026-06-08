import SwiftUI

struct PracticeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("待完成") {
                    Text("数学 - 二次函数 (3题)")
                    Text("英语 - 时态辨析 (2题)")
                }
                Section("已完成") {
                    Text("数学 - 一元二次方程 (5题)")
                }
            }
            .navigationTitle("推荐练习")
        }
    }
}
