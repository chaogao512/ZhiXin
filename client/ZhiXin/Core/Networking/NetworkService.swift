import Foundation

@Observable
final class NetworkService {
    static let shared = NetworkService()
    private let baseURL = ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "http://localhost:8000"
    private let session = URLSession.shared

    func request<T: Decodable>(_ endpoint: String, method: String = "GET",
                                body: Data? = nil) async throws -> T {
        let url = URL(string: "\(baseURL)/api/v1\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func upload(_ endpoint: String, data: Data, fieldName: String = "file",
                fileName: String, mimeType: String) async throws -> UploadResponse {
        let url = URL(string: "\(baseURL)/api/v1\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let (responseData, _) = try await session.data(for: request)
        return try JSONDecoder().decode(UploadResponse.self, from: responseData)
    }
}

struct UploadResponse: Codable {
    let fileURL: String
}
