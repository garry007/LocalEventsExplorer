import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Query private var bookmarks: [Bookmark]
    @Query(sort: \StoredEvent.time) private var storedEvents: [StoredEvent]

    private var bookmarkedEvents: [Event] {
        storedEvents
            .filter { stored in bookmarks.contains(where: { $0.eventId == stored.id }) }
            .map { $0.toEvent() }
    }

    var body: some View {
        NavigationStack {
            Group {
                if bookmarkedEvents.isEmpty {
                    ContentUnavailableView("No Bookmarks", systemImage: "bookmark", description: Text("Saved events will appear here."))
                } else {
                    List(bookmarkedEvents) { event in
                        NavigationLink(value: event.id) {
                            EventRowView(event: event, distanceText: event.time.formatted(date: .abbreviated, time: .shortened))
                        }
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .navigationDestination(for: String.self) { eventId in
                if let event = bookmarkedEvents.first(where: { $0.id == eventId }) {
                    EventDetailView(event: event)
                }
            }
        }
    }
}
