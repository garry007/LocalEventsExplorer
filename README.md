# LocalEventsExplorer

A small SwiftUI-based mobile application built as part of a mobile developer technical assessment.

The app displays nearby local events, allows bookmarking events, supports offline image caching, stores local data using SwiftData, and integrates with Apple Maps for navigation.

---

# Features

- Browse nearby local events
- Event details screen
- Bookmark and remove bookmarked events
- Local persistence using SwiftData
- Last fetched events stored locally
- Offline image caching using memory + disk cache
- Location permission and distance calculation
- Open event location in Apple Maps
- Graceful fallback handling for failed loading states

---

# Tech Stack

- Swift
- SwiftUI
- SwiftData
- MVVM Architecture
- Repository Pattern
- MapKit
- CoreLocation

---

# Architecture

The app uses a lightweight MVVM architecture with a repository layer to separate UI, business logic, and data handling.

Main layers:
- Views
- ViewModels
- Repository
- Services
- Persistence Layer

The repository layer acts as the single source of truth and handles:
- loading events
- refreshing cache
- local persistence fallback

---

# Important Files

```text
ContentView.swift
Root tab structure for Events and Bookmarks

EventsListView.swift
Displays local events and handles navigation

EventsListViewModel.swift
Handles loading state, errors, and distance formatting

EventRepository.swift
Loads events from JSON/API service and updates local cache

EventAPIService.swift
Reads mock event data from events.json

EventDetailView.swift
Shows event details, bookmarking, and Maps deep link

BookmarksView.swift
Displays bookmarked events

CachedAsyncImage.swift
Displays remote images with cache support

ImageCacheService.swift
Handles memory and disk image caching

StoredEvent.swift
SwiftData model for cached events

Bookmark.swift
SwiftData model for bookmarked events

LocationService.swift
Requests and exposes user location

events.json
Mock local event data used for assignment scope
```

---

# Caching Strategy

The app stores fetched events locally using SwiftData and refreshes them through the repository layer.

Images are cached using:
- in-memory cache
- disk cache

This allows previously loaded images to remain available even after app relaunch or temporary network loss.

---

# Running the Project

1. Open the project in Xcode
2. Build and run on iOS Simulator or physical device
3. Allow location access when prompted

Requirements:
- Xcode 16+
- iOS 17+

---

# Tradeoffs / Notes

Since the assignment is intentionally time-boxed, a bundled JSON file was used as the mock API source instead of a real backend service.

The repository and service layers were separated so the mock source can later be replaced with a real REST API without major UI changes.

The focus of the implementation was:
- clean architecture
- maintainability
- offline handling
- practical engineering decisions within assignment scope

---

# Future Improvements

- Real REST API integration
- Event search and filtering
- Pagination support
- Smarter cache invalidation strategy
- Better background refresh handling
- Improved accessibility support
- Analytics and logging

---

# Unit Tests

Basic unit tests were added for:
- repository loading logic
- bookmark handling
- caching related behavior

---

# Demo

The demo video showcases:
- event listing
- event details
- bookmarks
- offline image caching
- maps integration

---

# Author

Gurpreet Singh
