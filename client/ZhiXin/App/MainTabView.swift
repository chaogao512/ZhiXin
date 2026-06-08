import SwiftUI

struct MainTabView: View {
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        switch authManager.currentUser?.role {
        case .student:
            StudentTabView()
        case .parent:
            #if os(macOS)
            ParentFullView()
            #else
            ParentTabView()
            #endif
        case .teacher:
            TeacherTabView()
        case nil:
            Text("加载中...")
        }
    }
}

struct StudentTabView: View {
    var body: some View {
        TabView {
            StudentDashboardView()
                .tabItem { Label("概览", systemImage: "chart.pie") }
            CameraCaptureView()
                .tabItem { Label("拍照", systemImage: "camera") }
            MistakeListView()
                .tabItem { Label("错题", systemImage: "list.bullet") }
            PracticeView()
                .tabItem { Label("练习", systemImage: "pencil") }
        }
    }
}

struct ParentTabView: View {
    var body: some View {
        TabView {
            ChildDashboardView()
                .tabItem { Label("概览", systemImage: "chart.pie") }
            AnalysisReportsView()
                .tabItem { Label("报告", systemImage: "doc.text") }
        }
    }
}

struct TeacherTabView: View {
    var body: some View {
        TabView {
            ClassManagementView()
                .tabItem { Label("班级", systemImage: "person.3") }
            MistakeAnalyticsView()
                .tabItem { Label("错题分析", systemImage: "chart.bar") }
            AssignmentView()
                .tabItem { Label("布置练习", systemImage: "square.and.pencil") }
        }
    }
}
