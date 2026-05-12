import Foundation
import SwiftData

@Model
final class StoredEvent {
    @Attribute(.unique) var id: String
    var title: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    var time: Date
    var imageURL: String
    var details: String
    var fetchedAt: Date

    init(event: Event, fetchedAt: Date = Date()) {
        self.id = event.id
        self.title = event.title
        self.locationName = event.locationName
        self.latitude = event.latitude
        self.longitude = event.longitude
        self.time = event.time
        self.imageURL = event.imageURL
        self.details = event.details
        self.fetchedAt = fetchedAt
    }

    func toEvent() -> Event {
        Event(id: id, title: title, locationName: locationName, latitude: latitude, longitude: longitude, time: time, imageURL: imageURL, details: details)
    }
}
