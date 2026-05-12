//
//  ImageCacheService.swift
//  LocalEventsExplorer
//
//  Created by Gurpreet Singh on 2026-05-12.
//

import Foundation

#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif

final class ImageCacheService {

    static let shared = ImageCacheService()

    private let memoryCache = NSCache<NSString, PlatformImage>()
    private let fileManager = FileManager.default
    private let cacheFolderName = "EventImages"

    private init() {
        createCacheFolderIfNeeded()
    }

    func image(for url: URL) -> PlatformImage? {

        let key = cacheKey(for: url)

        if let memoryImage = memoryCache.object(forKey: key as NSString) {
            return memoryImage
        }

        guard let data = try? Data(contentsOf: diskURL(for: key)) else {
            return nil
        }

        #if canImport(UIKit)
        guard let image = UIImage(data: data) else {
            return nil
        }
        #elseif canImport(AppKit)
        guard let image = NSImage(data: data) else {
            return nil
        }
        #endif

        memoryCache.setObject(image, forKey: key as NSString)
        return image
    }

    func setImage(_ image: PlatformImage, data: Data, for url: URL) {

        let key = cacheKey(for: url)

        memoryCache.setObject(image, forKey: key as NSString)

        do {
            try data.write(to: diskURL(for: key), options: [.atomic])
        } catch {
            print("Image disk cache write failed: \(error.localizedDescription)")
        }
    }

    func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }

    private func createCacheFolderIfNeeded() {

        let folderURL = cacheDirectory()

        if !fileManager.fileExists(atPath: folderURL.path) {
            try? fileManager.createDirectory(
                at: folderURL,
                withIntermediateDirectories: true
            )
        }
    }

    private func cacheDirectory() -> URL {

        let baseURL = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0]

        return baseURL.appendingPathComponent(cacheFolderName)
    }

    private func diskURL(for key: String) -> URL {
        cacheDirectory().appendingPathComponent(key)
    }

    private func cacheKey(for url: URL) -> String {

        let raw = url.absoluteString
        let safe = raw
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")
            .replacingOccurrences(of: "?", with: "_")
            .replacingOccurrences(of: "&", with: "_")
            .replacingOccurrences(of: "=", with: "_")

        return safe + ".img"
    }
}
