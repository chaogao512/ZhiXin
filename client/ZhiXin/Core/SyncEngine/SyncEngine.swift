import Foundation
import SwiftData

@Observable
final class SyncEngine {
    private let modelContext: ModelContext
    private let networkService = NetworkService.shared

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func syncPendingMistakes() async throws {
        let descriptor = FetchDescriptor<Mistake>()
        let all = try modelContext.fetch(descriptor)
        let pending = all.filter { $0.syncStatus == .pending }

        for mistake in pending {
            mistake.syncStatus = .syncing
            try modelContext.save()

            do {
                try await uploadMistake(mistake)
                mistake.syncStatus = .synced
            } catch {
                mistake.syncStatus = .failed
            }
            try modelContext.save()
        }
    }

    private func uploadMistake(_ mistake: Mistake) async throws {
        let body = MistakeCreateBody(
            subjectID: nil,
            chapterID: nil,
            studentAnswer: mistake.studentAnswer,
            correctAnswer: mistake.correctAnswer,
            ocrText: mistake.ocrText,
            photoURLs: nil,
            source: "manual"
        )
        let _: MistakeResponse = try await networkService.request(
            "/mistakes", method: "POST", body: body
        )
    }
}
