import Foundation
import SwiftData

@Model
final class Mistake {
    @Attribute(.unique) var id: String
    var studentID: String
    var subject: String
    var chapter: String?
    var photoURL: String?
    var ocrText: String
    var studentAnswer: String
    var correctAnswer: String
    var errorType: String?
    var createdAt: Date
    var syncStatus: SyncStatus

    init(id: String, studentID: String, subject: String, ocrText: String,
         studentAnswer: String, correctAnswer: String) {
        self.id = id
        self.studentID = studentID
        self.subject = subject
        self.ocrText = ocrText
        self.studentAnswer = studentAnswer
        self.correctAnswer = correctAnswer
        self.createdAt = Date()
        self.syncStatus = .pending
    }
}

enum SyncStatus: String, Codable {
    case pending
    case syncing
    case synced
    case failed
}
