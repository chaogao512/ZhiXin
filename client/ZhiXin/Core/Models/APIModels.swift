import Foundation

enum UserRole: String, Codable {
    case student
    case parent
    case teacher
}

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

struct MistakeResponse: Codable, Identifiable {
    let id: String
    let studentID: String
    let subjectID: String?
    let chapterID: String?
    let photoURLs: [String]?
    let ocrText: String
    let studentAnswer: String
    let correctAnswer: String
    let errorType: String?
    let confidenceScore: Double?
    let isConfirmed: Int
    let isMastered: Int
    let studentRemarks: String?
    let teacherComment: String?
    let analysisStatus: String
    let source: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case studentID = "student_id"
        case subjectID = "subject_id"
        case chapterID = "chapter_id"
        case photoURLs = "photo_urls"
        case ocrText = "ocr_text"
        case studentAnswer = "student_answer"
        case correctAnswer = "correct_answer"
        case errorType = "error_type"
        case confidenceScore = "confidence_score"
        case isConfirmed = "is_confirmed"
        case isMastered = "is_mastered"
        case studentRemarks = "student_remarks"
        case teacherComment = "teacher_comment"
        case analysisStatus = "analysis_status"
        case source
        case createdAt = "created_at"
    }
}

struct AnalysisResultResponse: Codable {
    let id: String
    let mistakeID: String
    let errorReason: String
    let solution: String
    let weaknessPoints: [String]
    let similarQuestions: [SimilarQuestion]
    let knowledgeMastery: Double?
    let suggestions: String?

    enum CodingKeys: String, CodingKey {
        case id
        case mistakeID = "mistake_id"
        case errorReason = "error_reason"
        case solution
        case weaknessPoints = "weakness_points"
        case similarQuestions = "similar_questions"
        case knowledgeMastery = "knowledge_mastery"
        case suggestions
    }
}

struct SimilarQuestion: Codable {
    let question: String
    let options: [String]
    let correctAnswer: String
    let explanation: String?

    enum CodingKeys: String, CodingKey {
        case question, options, explanation
        case correctAnswer = "correct_answer"
    }
}

struct ClassResponse: Codable, Identifiable {
    let id: String
    let name: String
    let inviteCode: String
    let subject: String
    let grade: String
    let studentCount: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, subject, grade
        case inviteCode = "invite_code"
        case studentCount = "student_count"
        case createdAt = "created_at"
    }
}

struct StudentInClass: Codable, Identifiable {
    let id: String
    let name: String
    let mistakeCount: Int
    let masteryLevel: Double?
    let isMarked: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case mistakeCount = "mistake_count"
        case masteryLevel = "mastery_level"
        case isMarked = "is_marked"
    }
}

struct MistakeCreateBody: Codable {
    let subjectID: String?
    let chapterID: String?
    let studentAnswer: String
    let correctAnswer: String
    let ocrText: String?
    let photoURLs: [String]?
    let source: String

    enum CodingKeys: String, CodingKey {
        case subjectID = "subject_id"
        case chapterID = "chapter_id"
        case studentAnswer = "student_answer"
        case correctAnswer = "correct_answer"
        case ocrText = "ocr_text"
        case photoURLs = "photo_urls"
        case source
    }
}

struct APIErrorResponse: Codable {
    let code: String
    let message: String
    let detail: String?
}
