import Foundation

enum UserRole: String, Codable {
    case student
    case parent
    case teacher
}

@Observable
final class AuthManager {
    var isAuthenticated = false
    var currentUser: User?

    struct User: Codable {
        let id: String
        let name: String
        let role: UserRole
        let avatarURL: URL?
    }

    func loginWithWeChat() async throws { }
    func loginWithAppleID() async throws { }
    func logout() { }
}
