//
//  CachedAsyncImage.swift
//  LocalEventsExplorer
//
//  Created by Gurpreet Singh on 2026-05-12.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct CachedAsyncImage: View {

    let urlString: String

    @State private var platformImage: PlatformImage?
    @State private var didFail = false

    var body: some View {

        Group {

            #if canImport(UIKit)

            if let image = platformImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }

            #elseif canImport(AppKit)

            if let image = platformImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }

            #else
            placeholder
            #endif
        }
        .clipped()
        .task {
            await loadImage()
        }
    }

    private var placeholder: some View {

        Rectangle()
            .fill(Color.gray.opacity(0.18))
            .overlay {
                if didFail {
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                } else {
                    ProgressView()
                }
            }
    }

    private func loadImage() async {

        guard let url = URL(string: urlString) else {
            didFail = true
            return
        }

        if let cachedImage = ImageCacheService.shared.image(for: url) {
            await MainActor.run {
                platformImage = cachedImage
                didFail = false
            }
            return
        }

        do {

            let (data, _) = try await URLSession.shared.data(from: url)

            #if canImport(UIKit)
            guard let downloadedImage = UIImage(data: data) else {
                await MainActor.run { didFail = true }
                return
            }
            #elseif canImport(AppKit)
            guard let downloadedImage = NSImage(data: data) else {
                await MainActor.run { didFail = true }
                return
            }
            #endif

            ImageCacheService.shared.setImage(
                downloadedImage,
                data: data,
                for: url
            )

            await MainActor.run {
                platformImage = downloadedImage
                didFail = false
            }

        } catch {

            // If download fails, we keep placeholder.
            // Disk cache is already checked above for offline use.
            await MainActor.run {
                didFail = true
            }
        }
    }
}
