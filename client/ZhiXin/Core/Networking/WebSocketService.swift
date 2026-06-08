import Foundation

@Observable
final class WebSocketService {
    private var webSocketTask: URLSessionWebSocketTask?
    private let session = URLSession.shared

    func connect(taskID: String) {
        let url = URL(string: "ws://localhost:8000/ws/v1/tasks/\(taskID)")!
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                print("Received: \(message)")
                self?.receiveMessage()
            case .failure(let error):
                print("WebSocket error: \(error)")
            }
        }
    }
}
