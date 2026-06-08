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
        let predicate = #Predicate<Mistake> { $0.syncStatus == .pending }
        let descriptor = FetchDescriptor(predicate: predicate)
        let pending = try modelContext.fetch(descriptor)

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
        let body = try JSONEncoder().encode(mistake)
        let _: UploadResponse = try await networkService.request("/mistakes",
            method: "POST", body: body)
    }
}
