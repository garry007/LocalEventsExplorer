import XCTest
@testable import LocalEventsExplorer

final class EventModelCodableTests: XCTestCase {
    func testEventDecodesFromJSON() throws {
        let json = """
        {
            "id": "evt_test",
            "title": "Test Event",
            "locationName": "Test Park",
            "latitude": 37.0,
            "longitude": -122.0,
            "time": "2026-05-20T11:00:00Z",
            "imageURL": "https://example.com/image.png",
            "details": "A test event"
        }
        """
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let evt = try decoder.decode(Event.self, from: data)
        XCTAssertEqual(evt.id, "evt_test")
        XCTAssertEqual(evt.title, "Test Event")
    }
}
