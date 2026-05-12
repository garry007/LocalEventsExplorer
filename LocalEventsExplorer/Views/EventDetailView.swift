//
//  EventDetailView.swift
//  LocalEventsExplorer
//
//  Created by Gurpreet Singh on 2026-05-12.
//

import SwiftUI
import SwiftData
import MapKit

struct EventDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var bookmarks: [Bookmark]

    let event: Event

    private var isBookmarked: Bool {
        bookmarks.contains { $0.eventId == event.id }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                CachedAsyncImage(urlString: event.imageURL)
                    .frame(maxWidth: .infinity)
                    .frame(height: 210)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.bottom, 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text(event.title)
                        .font(.title2.weight(.bold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)

                    Label(event.locationName, systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Label(event.time.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Divider()
                    .padding(.vertical, 4)

                Text(event.details)
                    .font(.body)
                    .lineSpacing(3)

                VStack(spacing: 10) {
                    Button {
                        toggleBookmark()
                    } label: {
                        Label(isBookmarked ? "Remove Bookmark" : "Bookmark Event", systemImage: isBookmarked ? "bookmark.fill" : "bookmark")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        openMaps()
                    } label: {
                        Label("Open in Maps", systemImage: "map")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 8)
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleBookmark() {
        if let bookmark = bookmarks.first(where: { $0.eventId == event.id }) {
            modelContext.delete(bookmark)
        } else {
            modelContext.insert(Bookmark(eventId: event.id))
        }
        try? modelContext.save()
    }

    private func openMaps() {
        let placemark = MKPlacemark(coordinate: event.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = event.title
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
