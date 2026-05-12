import Foundation
import CoreLocation

struct Event: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let locationName: String
    let latitude: Double
    let longitude: Double
    let time: Date
    let imageURL: String
    let details: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
