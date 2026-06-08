import SwiftUI

struct MainTabView: View {
    @Environment(UserManager.self) private var userManager

    var body: some View {
        switch userManager.currentUser?.userRole {
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
            ProgressView("加载中...")
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

            ProfileView()
                .tabItem { Label("我的", systemImage: "person.circle") }
        }
        .tint(.orange)
    }
}

struct ParentTabView: View {
    var body: some View {
        TabView {
            ChildDashboardView()
                .tabItem { Label("概览", systemImage: "chart.pie") }

            AnalysisReportsView()
                .tabItem { Label("报告", systemImage: "doc.text") }

            ReviewCheckView()
                .tabItem { Label("复习检查", systemImage: "camera.viewfinder") }

            ProfileView()
                .tabItem { Label("我的", systemImage: "person.circle") }
        }
        .tint(.blue)
    }
}

struct TeacherTabView: View {
    var body: some View {
        TabView {
            ClassManagementView()
                .tabItem { Label("班级", systemImage: "person.3") }

            MistakeAnalyticsView()
                .tabItem { Label("分析", systemImage: "chart.bar") }

            AssignmentView()
                .tabItem { Label("练习", systemImage: "square.and.pencil") }

            TeacherProfileTab()
        }
        .tint(.indigo)
    }
}

struct TeacherProfileTab: View {
    var body: some View {
        #if os(iOS)
        ProfileView()
            .tabItem { Label("我的", systemImage: "person.circle") }
        #else
        AnalysisConfigView()
            .tabItem { Label("策略", systemImage: "gearshape.2") }
        ProfileView()
            .tabItem { Label("我的", systemImage: "person.circle") }
        #endif
    }
}
