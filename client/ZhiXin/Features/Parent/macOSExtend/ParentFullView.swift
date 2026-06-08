import SwiftUI

struct ParentFullView: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink("学习概览") { ChildDashboardView() }
                NavigationLink("分析报告") { AnalysisReportsView() }
                NavigationLink("错题详情") { MistakeDetailView(mistakeID: "") }
                NavigationLink("学习趋势") { Text("学习趋势") }
                NavigationLink("设置") { Text("设置") }
            }
            .listStyle(.sidebar)
        } detail: {
            ChildDashboardView()
        }
    }
}
