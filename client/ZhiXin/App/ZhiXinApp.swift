import SwiftUI

@main
struct ZhiXinApp: App {
    @State private var authManager = AuthManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isAuthenticated {
                    MainTabView()
                        .environment(authManager)
                } else {
                    AuthView()
                        .environment(authManager)
                }
            }
        }
        #if os(macOS)
        .windowResizability(.contentMinSize)
        .windowStyle(.automatic)
        #endif
    }
}
