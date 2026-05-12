//
//  EventsListView.swift
//  LocalEventsExplorer
//
//  Created by Gurpreet Singh on 2026-05-12.
//

import SwiftUI
import SwiftData

struct EventsListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = EventsListViewModel()
    @StateObject private var locationService = LocationService()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading events...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView("Something went wrong", systemImage: "exclamationmark.triangle", description: Text(error))
                } else {
                    List(viewModel.events) { event in
                        NavigationLink(value: event.id) {
                            EventRowView(event: event, distanceText: viewModel.distanceText(from: locationService.userLocation, to: event))
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("Local Events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Refresh") {
                    Task { await viewModel.loadEvents(context: modelContext) }
                }
            }
            .navigationDestination(for: String.self) { eventId in
                if let event = viewModel.events.first(where: { $0.id == eventId }) {
                    EventDetailView(event: event)
                }
            }
            .task {
                locationService.requestLocation()
                await viewModel.loadEvents(context: modelContext)
            }
        }
    }
}
