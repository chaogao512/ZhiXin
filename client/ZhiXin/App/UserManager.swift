import Foundation
import UIKit

private struct UserSetupBody: Encodable {
    let userId: String
    let name: String
    let role: String
    let deviceModel: String
    let systemName: String
    let systemVersion: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name, role
        case deviceModel = "device_model"
        case systemName = "system_name"
        case systemVersion = "system_version"
    }
}

private struct UserUpdateBody: Encodable {
    let name: String
}

@MainActor @Observable
final class UserManager {
    var currentUser: UserInfo?
    var isLoading = false
    var errorMessage: String?
    var hasCurrentSession = false
    private(set) var accountListVersion = 0

    var isSetup: Bool {
        UserDefaults.standard.string(forKey: "current_user_id") != nil
    }

    var userId: String {
        UserDefaults.standard.string(forKey: "current_user_id") ?? "未设置"
    }

    /// 本机所有已知账户 `[uuid: 名称]`
    var savedAccounts: [(id: String, name: String)] {
        _ = accountListVersion
        guard let data = UserDefaults.standard.dictionary(forKey: "saved_accounts") as? [String: String]
        else { return [] }
        return data.map { ($0.key, $0.value) }.sorted { $0.name < $1.name }
    }

    private var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let bytes = mirror.children.map { $0.value as! Int8 }
        return String(cString: bytes).trimmingCharacters(in: .whitespaces)
    }

    private let network = NetworkService.shared

    // MARK: - 创建新账户（总是新 UUID）

    func createAccount(name: String, role: String) async {
        isLoading = true
        errorMessage = nil

        let id = UUID().uuidString
        network.userId = id

        let body = UserSetupBody(
            userId: id,
            name: name,
            role: role,
            deviceModel: deviceModel,
            systemName: UIDevice.current.systemName,
            systemVersion: UIDevice.current.systemVersion
        )

        do {
            let response: UserInfo = try await network.request(
                "/auth/setup", method: "POST", body: body
            )
            saveAccount(id: id, name: response.name)
            UserDefaults.standard.set(id, forKey: "current_user_id")
            currentUser = response
            hasCurrentSession = true
        } catch {
            saveAccount(id: id, name: name)
            UserDefaults.standard.set(id, forKey: "current_user_id")
            currentUser = UserInfo(id: id, name: name, role: role, avatarURL: nil)
            hasCurrentSession = true
        }
        isLoading = false
    }

    // MARK: - 切换已有账户

    func switchToAccount(id: String) async {
        isLoading = true
        errorMessage = nil
        network.userId = id

        do {
            let response: UserInfo = try await network.request("/auth/me")
            saveAccount(id: id, name: response.name)
            UserDefaults.standard.set(id, forKey: "current_user_id")
            currentUser = response
            hasCurrentSession = true
        } catch APIError.notFound {
            removeSavedAccount(id: id)
        } catch {
            let savedName = savedAccounts.first(where: { $0.id == id })?.name ?? "用户"
            UserDefaults.standard.set(id, forKey: "current_user_id")
            currentUser = UserInfo(id: id, name: savedName, role: "student", avatarURL: nil)
            hasCurrentSession = true
        }
        isLoading = false
    }

    // MARK: - 恢复上次会话

    func restoreSession() {
        guard let id = UserDefaults.standard.string(forKey: "current_user_id") else { return }
        network.userId = id

        let savedName = savedAccounts.first(where: { $0.id == id })?.name ?? "用户"
        currentUser = UserInfo(id: id, name: savedName, role: "student", avatarURL: nil)
        hasCurrentSession = true

        Task { @MainActor in
            do {
                let response: UserInfo = try await network.request("/auth/me")
                currentUser = response
            } catch APIError.notFound {
                removeSavedAccount(id: id)
            } catch {
                // 离线时保留本地用户信息
            }
        }
    }

    // MARK: - 修改昵称

    func changeName(_ newName: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let body = UserUpdateBody(name: newName)
            let response: UserInfo = try await network.request(
                "/auth/me", method: "PUT", body: body
            )
            updateAccountName(id: userId, name: newName)
            currentUser = response
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - 退出（回到账户选择）

    func logout() {
        UserDefaults.standard.removeObject(forKey: "current_user_id")
        network.userId = nil
        currentUser = nil
        hasCurrentSession = false
    }

    /// 从本机删除账户记录
    func removeSavedAccount(id: String) {
        guard var dict = UserDefaults.standard.dictionary(forKey: "saved_accounts") as? [String: String]
        else { return }
        dict.removeValue(forKey: id)
        UserDefaults.standard.set(dict, forKey: "saved_accounts")
        accountListVersion += 1

        if id == userId {
            logout()
        }
    }

    // MARK: - Private

    private func saveAccount(id: String, name: String) {
        var dict = UserDefaults.standard.dictionary(forKey: "saved_accounts") as? [String: String] ?? [:]
        dict[id] = name
        UserDefaults.standard.set(dict, forKey: "saved_accounts")
        accountListVersion += 1
    }

    private func updateAccountName(id: String, name: String) {
        guard var dict = UserDefaults.standard.dictionary(forKey: "saved_accounts") as? [String: String]
        else { return }
        dict[id] = name
        UserDefaults.standard.set(dict, forKey: "saved_accounts")
        accountListVersion += 1
    }
}
