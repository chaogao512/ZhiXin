import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(String)
    case notFound
    case notSetUp

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "无效的 URL"
        case .noData: return "无返回数据"
        case .decodingError(let e): return "数据解析失败: \(e.localizedDescription)"
        case .serverError(let m): return m
        case .notFound: return "资源不存在"
        case .notSetUp: return "用户未设置"
        }
    }
}

@Observable
final class NetworkService {
    static let shared = NetworkService()

    var userId: String?

    var baseURL: String {
        ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "http://127.0.0.1:8000"
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
        body: Encodable? = nil
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)/api/v1\(path)") else {
            throw APIError.invalidURL
        }

        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let id = userId {
            req.setValue(id, forHTTPHeaderField: "X-User-Id")
        }

        if let body = body {
            req.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await session.data(for: req)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.serverError("无效响应")
        }

        if httpResponse.statusCode == 404 {
            throw APIError.notFound
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
}
