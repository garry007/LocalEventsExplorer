import Foundation
import SwiftData

protocol EventRepositoryProtocol {
    @MainActor
    func loadEvents(context: ModelContext) async throws -> [Event]
}

final class EventRepository: EventRepositoryProtocol {
    private let apiService: EventAPIServiceProtocol
    private let ttl: TimeInterval

    init(apiService: EventAPIServiceProtocol = EventAPIService(), ttl: TimeInterval = 60 * 30) {
        self.apiService = apiService
        self.ttl = ttl
    }

    @MainActor
    func loadEvents(context: ModelContext) async throws -> [Event] {

        do {

            // Always fetch latest events from local JSON
            let events = try await apiService.fetchEvents()

            // Refresh local cache
            try replaceCachedEvents(events, context: context)

            return events.sorted { $0.time < $1.time }

        } catch {

            // Fallback to cached events if JSON/API fails
            let descriptor = FetchDescriptor<StoredEvent>(
                sortBy: [SortDescriptor(\.time)]
            )

            let storedEvents = try context.fetch(descriptor)

            if !storedEvents.isEmpty {
                return storedEvents.map { $0.toEvent() }
            }

            throw error
        }
    }
    @MainActor
    private func replaceCachedEvents(_ events: [Event], context: ModelContext) throws {
        let existing = try context.fetch(FetchDescriptor<StoredEvent>())
        existing.forEach { context.delete($0) }
        events.forEach { context.insert(StoredEvent(event: $0)) }
        try context.save()
    }
}
