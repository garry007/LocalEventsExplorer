import Foundation
import SwiftData

@Model
final class Bookmark {
    @Attribute(.unique) var eventId: String
    var createdAt: Date

    init(eventId: String, createdAt: Date = Date()) {
        self.eventId = eventId
        self.createdAt = createdAt
    }
}
