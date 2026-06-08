import SwiftUI
import Charts

struct ChildDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ChildSelectorView()
                    SubjectMasteryChart()
                    RecentMistakesSection()
                }
                .padding()
            }
            .navigationTitle("学习概览")
        }
    }
}

struct ChildSelectorView: View {
    var body: some View {
        Menu("选择孩子: 张三") {
            Button("张三") { }
            Button("李四") { }
        }
        .menuStyle(.button)
        .buttonStyle(.bordered)
    }
}
