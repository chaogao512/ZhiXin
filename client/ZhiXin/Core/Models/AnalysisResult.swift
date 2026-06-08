import Foundation
import SwiftData

@Model
final class AnalysisResult {
    @Attribute(.unique) var id: String
    var mistakeID: String
    var errorReason: String
    var solution: String
    var weaknessPoints: [String]
    var similarQuestions: [SimilarQuestion]
    var knowledgeMastery: Double
    var suggestions: String
    var createdAt: Date

    init(id: String, mistakeID: String, errorReason: String, solution: String,
         weaknessPoints: [String], similarQuestions: [SimilarQuestion],
         knowledgeMastery: Double, suggestions: String) {
        self.id = id
        self.mistakeID = mistakeID
        self.errorReason = errorReason
        self.solution = solution
        self.weaknessPoints = weaknessPoints
        self.similarQuestions = similarQuestions
        self.knowledgeMastery = knowledgeMastery
        self.suggestions = suggestions
        self.createdAt = Date()
    }
}

struct SimilarQuestion: Codable {
    let question: String
    let options: [String]
    let correctAnswer: String
}
