//
//  EventRowView.swift
//  LocalEventsExplorer
//
//  Created by Gurpreet Singh on 2026-05-12.
//

import SwiftUI

struct EventRowView: View {
    let event: Event
    let distanceText: String

    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImage(urlString: event.imageURL)
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(event.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(event.locationName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text(distanceText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
