import Foundation

enum UserRole: String, Codable {
    case student
    case parent
    case teacher
}

@Observable
final class AuthManager {
    var isAuthenticated = false
    var currentUser: UserInfo?
    var isLoading = false
    var errorMessage: String?

    struct UserInfo: Codable {
        let id: String
        let name: String
        let role: String
        let avatarURL: String?

        var userRole: UserRole? { UserRole(rawValue: role) }

        enum CodingKeys: String, CodingKey {
            case id, name, role
            case avatarURL = "avatar_url"
        }
    }

    private let network = NetworkService.shared

    func loginWithApple(token: String, name: String? = nil) async {
        isLoading = true
        errorMessage = nil
        do {
            let body = ["apple_token": token, "name": name].compactMapValues { $0 }
            let response: LoginResponse = try await network.request(
                "/auth/login/apple", method: "POST", body: body, auth: false
            )
            network.accessToken = response.accessToken
            currentUser = response.user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loginWithWeChat(code: String, name: String? = nil) async {
        isLoading = true
        errorMessage = nil
        do {
            let body = ["code": code, "name": name].compactMapValues { $0 }
            let response: LoginResponse = try await network.request(
                "/auth/login/wechat", method: "POST", body: body, auth: false
            )
            network.accessToken = response.accessToken
            currentUser = response.user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func logout() {
        network.accessToken = nil
        currentUser = nil
        isAuthenticated = false
    }
}
