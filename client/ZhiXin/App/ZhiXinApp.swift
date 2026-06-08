import SwiftUI

@main
struct ZhiXinApp: App {
    @State private var userManager = UserManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if userManager.hasCurrentSession {
                    MainTabView()
                        .environment(userManager)
                } else if userManager.savedAccounts.isEmpty {
                    SetupView()
                        .environment(userManager)
                        .onAppear {
                            if userManager.isSetup {
                                userManager.restoreSession()
                            }
                        }
                } else {
                    AccountPickerView()
                        .environment(userManager)
                }
            }
        }
        #if os(macOS)
        .windowResizability(.contentMinSize)
        .windowStyle(.automatic)
        #endif
    }
}
