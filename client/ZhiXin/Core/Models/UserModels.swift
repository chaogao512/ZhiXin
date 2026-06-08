import Foundation

struct Student: Codable, Identifiable {
    let id: String
    let name: String
    let grade: String
    let subjects: [SubjectInfo]
}

struct SubjectInfo: Codable, Identifiable {
    var id: String { name }
    let name: String
    let totalMistakes: Int
    let masteryLevel: Double
}

struct ParentChild: Codable, Identifiable {
    let id: String
    let name: String
    let grade: String
    let recentActivity: Date
}

struct ClassInfo: Codable, Identifiable {
    let id: String
    let name: String
    let subject: String
    let grade: String
    let inviteCode: String
    let studentCount: Int
}

struct ClassStudent: Codable, Identifiable {
    let id: String
    let name: String
    let mistakeCount: Int
    let masteryLevel: Double
}
