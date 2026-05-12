import Foundation
import SwiftData
import CoreLocation

@MainActor
final class EventsListViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: EventRepositoryProtocol

    init(repository: EventRepositoryProtocol = EventRepository()) {
        self.repository = repository
    }

    func loadEvents(context: ModelContext) async {
        isLoading = true
        errorMessage = nil
        do {
            events = try await repository.loadEvents(context: context)
        } catch {
            errorMessage = "Unable to load events. Please try again."
        }
        isLoading = false
    }

    func distanceText(from userLocation: CLLocation?, to event: Event) -> String {
        guard let userLocation else { return "Distance unavailable" }
        let eventLocation = CLLocation(latitude: event.latitude, longitude: event.longitude)
        let distanceKm = userLocation.distance(from: eventLocation) / 1000
        return String(format: "%.1f km away", distanceKm)
    }
}
