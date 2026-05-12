import XCTest
@testable import LocalEventsExplorer

final class EventAPIServiceTests: XCTestCase {
    func testFetchEventsDecodesJSON() async throws {
        let service = EventAPIService()
        let events = try await service.fetchEvents()
        XCTAssertFalse(events.isEmpty, "Expected events to be decoded from events.json")
        // Basic sanity checks
        let first = events[0]
        XCTAssertFalse(first.title.isEmpty)
        XCTAssertNotNil(first.imageURL)
    }
}
