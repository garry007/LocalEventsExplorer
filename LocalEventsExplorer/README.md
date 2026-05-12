# LocalEventsExplorer

A small SwiftUI app for the Mobile Developer technical assignment. It lists local events, supports bookmarks, caches fetched events locally, caches images in memory (and on disk), requests location permission, shows event distance, and opens Apple Maps for navigation. It also includes a launch storyboard so the app presents full-screen on modern iOS devices and a background refresh task registration.

## Tech Stack
- Swift
- SwiftUI
- SwiftData
- MVVM
- Repository Pattern
- async/await
- CoreLocation
- MapKit

## Run Steps
1. Open the Xcode project.
2. Add all files from this pack to the main app target.
3. Add `events.json` to Copy Bundle Resources.
4. Add location permission text to Info.plist.
5. Build and run on simulator or device.
6. Important: if you previously installed the app on the simulator/device, delete the existing app first and Clean Build Folder (Product → Clean Build Folder) to ensure the new `LaunchScreen.storyboard` is used and the app launches full-screen.

## Architecture
SwiftUI Views talk to ViewModels. ViewModels call Repository. Repository decides whether to use cached local data or fetch fresh data from the API service. SwiftData stores last-fetched events and bookmarks. ImageCacheService provides in-memory image caching.

## Tradeoffs
- A local JSON file is used as the mock API source to keep the assignment time-boxed.
- SwiftData is used for persistence because it keeps local database code small and readable.
- Image caching is in-memory using NSCache. Disk image caching can be added later.
- TTL caching is set to 30 minutes.
 - Image caching is both in-memory (NSCache) and persisted to the app Caches directory for offline use (SHA256-based filenames).
 - TTL caching is set to 30 minutes.

## Developer notes
- Models: `StoredEvent` and `Bookmark` are SwiftData `@Model` objects used for local persistence.
- Repository: `EventRepository` implements TTL-based caching and replaces stored events after a successful fetch.
- Image cache: `ImageCacheService` caches images in memory and writes them to Caches/LocalEventsExplorerImageCache so images are available offline. Use `ImageCacheService.shared.clear()` to clear memory and disk cache.
- Launch screen: `LaunchScreen.storyboard` is included and `Info.plist` contains `UILaunchStoryboardName = LaunchScreen` to avoid compatibility-scaling and ensure full-screen presentation.
- Background tasks: `LocalEventsExplorerApp.swift` registers a BGAppRefreshTask identifier; see `Info.plist` for permitted identifiers.
- Bookmarks: removing a bookmark deletes both the `Bookmark` and the corresponding `StoredEvent` so the Bookmarks list updates automatically.

## Pushing to GitHub
Recommended `.gitignore` entries for Xcode projects:
```
# Xcode
build/
DerivedData/
*.xcuserdata
*.xcscmblueprint

# Swift package manager
/.build/

# CocoaPods
Pods/

# misc
.DS_Store
```

To push the project to GitHub from the terminal:
```
cd /path/to/LocalEventsExplorer
git init
git add -A
git commit -m "Initial commit — LocalEventsExplorer"
git remote add origin https://github.com/<USERNAME>/<REPO>.git
git branch -M main
git push -u origin main
```

Replace `<USERNAME>` and `<REPO>` with your GitHub username and repository name.

## Required Features Covered
- Event list
- Event detail
- Bookmarks
- Local persistence
- API abstraction using mock JSON
- TTL cache for events
- Image cache
- Location permission
- Distance calculation
- Deep link to Apple Maps
