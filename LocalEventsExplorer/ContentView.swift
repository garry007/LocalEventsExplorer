//
//  ContentView.swift
//  LocalEventsExplorer
//
//  Created by Gurpreet Singh on 2026-05-12.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            EventsListView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }

            BookmarksView()
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [StoredEvent.self, Bookmark.self], inMemory: true)
}
