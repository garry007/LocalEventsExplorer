//
//  LocalEventsExplorerApp.swift
//  LocalEventsExplorer
//
//  Created by Gurpreet Singh on 2026-05-12.
//

import SwiftUI
import SwiftData
import BackgroundTasks

@main
struct LocalEventsExplorerApp: App {
    @Environment(\.scenePhase) private var scenePhase

    private let refreshIdentifier = "com.gurpreetsingh.localeventsexplorer.refresh"

    init() {
        registerBackgroundTasks()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .dynamicTypeSize(.medium)
                .task {
                    scheduleAppRefresh()
                }
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .background {
                        scheduleAppRefresh()
                    }
                }
        }
        .modelContainer(for: [StoredEvent.self, Bookmark.self])
    }

    // MARK: - Background Refresh

    private func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: refreshIdentifier, using: nil) { task in
            guard let appRefreshTask = task as? BGAppRefreshTask else {
                task.setTaskCompleted(success: false)
                return
            }

            scheduleAppRefresh()

            let operation = BlockOperation {
                // Lightweight placeholder refresh for assignment scope.
                // Real API refresh can be connected here later.
                sleep(1)
            }

            operation.completionBlock = {
                appRefreshTask.setTaskCompleted(success: !operation.isCancelled)
            }

            appRefreshTask.expirationHandler = {
                operation.cancel()
            }

            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1
            queue.addOperation(operation)
        }
    }

    private func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: refreshIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 4 * 60 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Background refresh scheduling failed: \(error.localizedDescription)")
        }
    }
}
