import SwiftUI

struct MistakeListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("数学") {
                    Text("二次函数顶点式 (2024-03-15)")
                    Text("一元二次方程求根 (2024-03-14)")
                }
                Section("英语") {
                    Text("过去完成时 (2024-03-13)")
                }
            }
            .navigationTitle("错题本")
        }
    }
}
