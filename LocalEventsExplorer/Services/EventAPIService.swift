import Foundation

protocol EventAPIServiceProtocol {
    func fetchEvents() async throws -> [Event]
}

final class EventAPIService: EventAPIServiceProtocol {
    func fetchEvents() async throws -> [Event] {
        guard let url = Bundle.main.url(forResource: "events", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Event].self, from: data)
    }
}
