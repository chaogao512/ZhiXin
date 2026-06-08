import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(String)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "无效的 URL"
        case .noData: return "无返回数据"
        case .decodingError(let e): return "数据解析失败: \(e.localizedDescription)"
        case .serverError(let m): return m
        case .unauthorized: return "登录已过期，请重新登录"
        }
    }
}

@Observable
final class NetworkService {
    static let shared = NetworkService()

    var accessToken: String?
    var baseURL: String {
        #if targetEnvironment(simulator) || os(macOS)
        return ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "http://127.0.0.1:8000"
        #else
        return ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "https://api.zhixin.app"
        #endif
    }

    private let session: URLSession
    private let decoder: JSONDecoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 120
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
    }

    func request<T: Decodable>(
        _ path: String,
        method: String = "GET",
        body: Encodable? = nil,
        auth: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)/api/v1\(path)") else {
            throw APIError.invalidURL
        }

        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if auth, let token = accessToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            req.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await session.data(for: req)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.serverError("无效响应")
        }

        if httpResponse.statusCode == 401 {
            throw APIError.unauthorized
        }

        if httpResponse.statusCode >= 400 {
            let error = try? decoder.decode(APIErrorResponse.self, from: data)
            throw APIError.serverError(error?.message ?? "请求失败 (\(httpResponse.statusCode))")
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func requestNoBody<T: Decodable>(
        _ path: String,
        method: String = "GET",
        auth: Bool = true
    ) async throws -> T {
        try await request(path, method: method, body: Optional<String>.none, auth: auth)
    }
}
